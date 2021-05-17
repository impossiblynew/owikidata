(*open Lwt
open Cohttp
open Cohttp_lwt_unix*)

module InternalJsonRep = Json_parsing_j

exception Bad_json_data of string
exception Not_implemented

type propertyid = string
type lang = string

let bad_json_data msg = raise (Bad_json_data msg)

(* Consider moving this inside the corresponding class for each *)
(* Maybe make it so that one can implement their own module for retrieving data*)
(*
module JsonData = struct
    
    exception Bad_response_code of int

    type entity = InternalJsonRep.entity
    let wikidata_base_url = "https://www.wikidata.org/wiki/Special:EntityData/"
      
    let get_json_from_api_lwt base_url id =
      let url = base_url ^ id ^ ".json" in
      Client.get (Uri.of_string url) >>= fun (resp, body) ->
      let code = resp |> Response.status |> Code.code_of_status in
      if code <> 200 then raise (Bad_response_code code)
      else body |> Cohttp_lwt.Body.to_string

    let get_json_from_api ?(base_url = wikidata_base_url) id =
      get_json_from_api_lwt base_url id |> Lwt_main.run

    (*TODO: make this work with single *)
    let data_of_json json =
      try InternalJsonRep.entity_of_string json 
      (*FIXME: use a more specific exception *)
      with _ -> match InternalJsonRep.entities_of_string json with
        | {entities = (_, entity)::_;} -> entity
        | _ -> bad_json_data "Empty entities dict"
    
    let get_data_from_api ?(base_url = wikidata_base_url) id = id |> (get_json_from_api ~base_url: base_url) |> data_of_json
end
*)
module Snak = struct
  type wikibase_entityid = {entity_type: string; id: string; numeric_id: int option}
  type globecoordinate = {latitude: float; longitude: float; precision: float option; globe: string}
  type quantity = {amount: float; upper_bound: float option; lower_bound: float option; quantity_unit: string}
  type time = {time: string; timezone: int; before: int option; after: int option; calendarmodel: string; precision: int} (*FIXME: FIX THIS*)
  type monolingualtext = {language: string; text: string}

  (*FIXME: consider using a GADT*)
  type data = 
  | CommonsMedia of string
  | GeographicShape of string
  | GlobeCoordinate of globecoordinate
  | MonolingualText of monolingualtext
  | Quantity of quantity
  | String of string
  | TabularData of string
  | Time of time
  | URL of string
  | ExternalIdentifier of string
  | Item of wikibase_entityid
  | Property of wikibase_entityid
  | MusicalNotation of string
  | MathematicalExpression of string
  | Lexeme of wikibase_entityid
  | Form of wikibase_entityid
  | Sense of wikibase_entityid

  type t = Value of data | SomeValue | NoValue

  let of_internal (data : InternalJsonRep.snak) = match data.snaktype with
    | `NoValue -> NoValue
    | `SomeValue -> SomeValue
    | `Value ->
        let value = match data.datatype, data.datavalue with
          | Some "commonsMedia", Some `String {value} -> CommonsMedia value
          | Some "globe-coordinate", Some `GlobeCoordinate {value = {latitude; longitude; precision; globe}} ->
            let to_float = function
            | `Float f -> f
            | `String s -> float_of_string s
            | `Int i -> float_of_int i
            | _ -> bad_json_data "field in globe-coordinate was not float or string" in
            let latitude  = to_float latitude in
            let longitude = to_float longitude in
            let precision = Option.map to_float precision in
              GlobeCoordinate {latitude; longitude; precision; globe}
          | Some "wikibase-item", Some `Wikibase_EntityId {value = {entity_type; id; numeric_id}} -> Item {entity_type; id; numeric_id}
          | Some "wikibase-property", Some `Wikibase_EntityId {value = {entity_type; id; numeric_id}} -> Property {entity_type; id; numeric_id}
          | Some "string", Some `String {value} -> String value
          | Some "monolingualtext", Some `MonolingualText {value = {language; text}} -> MonolingualText {language; text}
          | Some "external-id", Some `String {value} -> ExternalIdentifier value
          | Some "quantity", Some `Quantity {value = {upperBound; lowerBound; amount; quantity_unit}} ->
              let to_float = function
              | Some s -> Some (float_of_string s) | None -> None in
              let upper_bound = to_float upperBound in
              let lower_bound = to_float lowerBound in
              let amount = float_of_string amount in
              Quantity {upper_bound; lower_bound; amount; quantity_unit}
          | Some "time", Some `Time {value = {time; timezone; before; after; precision; calendarmodel}} ->
                Time {time; timezone; before; after; precision; calendarmodel}
          | Some "url", Some `String {value} -> URL value
          | Some "math", Some `String {value} -> MathematicalExpression value
          | Some "geo-shape", Some `String {value} -> GeographicShape value
          | Some "musical-notation", Some `String {value} -> MusicalNotation value
          | Some "tabular-data", Some `String {value} -> TabularData value
          | Some "wikibase-lexeme", Some `Wikibase_EntityId {value = {entity_type; id; numeric_id}} -> Lexeme {entity_type; id; numeric_id}
          | Some "wikibase-form", Some `Wikibase_EntityId {value = {entity_type; id; numeric_id}} -> Form {entity_type; id; numeric_id}
          | Some "wikibase-sense", Some `Wikibase_EntityId {value = {entity_type; id; numeric_id}} -> Sense {entity_type; id; numeric_id}
          | None, _ -> bad_json_data "datatype is none despite snaktype being value"
          | _, None -> bad_json_data "datavalue is none despite snaktype being value"
          | Some s, _ -> bad_json_data ("mismatched datatype and valuetype or unexpected datatype: " ^ s)
        in
          Value value
  let of_string s = s |> InternalJsonRep.snak_of_string |> of_internal
end


module Statement = struct 
  type rank = Preferred | Normal | Deprecated
  type reference = {hash: string; snaks: (string * Snak.t list) list; snaks_order : string list;} (*FIXME: snak order*)
  type t = {
    id: string;
    rank: rank;
    mainsnak: Snak.t;
    qualifiers: (string * Snak.t list) list;
    references: reference list;
  }
  let of_internal (data : InternalJsonRep.statement) : t =
    let id = data.id in
    let rank = match data.rank with
    | `Preferred -> Preferred
    |  `Normal -> Normal
    | `Deprecated -> Deprecated in
    let mainsnak = Snak.of_internal data.mainsnak in
    let qualifiers = match data.qualifiers with
    | Some l -> List.map (fun (p, snaks) -> p, List.map Snak.of_internal snaks) l
    | None -> [] in
    let references = match data.references with
    | Some refs ->
          List.map
          (fun (r: InternalJsonRep.reference) ->
            {
              hash = r.hash;
              snaks = (List.map (fun (p, s) -> (p, List.map Snak.of_internal s)) r.snaks);
              snaks_order = r.snaks_order;
            }) 
          refs
    | None -> [] in
    {id; rank; mainsnak; qualifiers; references}
  let of_string s = s |> InternalJsonRep.statement_of_string |> of_internal
end

module Entity = struct
  class basic_entity
      ~(id : string)
      ~(entity_type : string)
      ~(labels : (lang * string) list)
      ~(descriptions : (lang * string) list)
      ~(aliases : (lang * string list) list) =
    object
      method id : string = id
      method entity_type : string = entity_type
      method label (lang : lang) : string = List.assoc lang labels
      method label_opt (lang : lang) : string option = List.assoc_opt lang labels
      method description (lang : lang) : string = List.assoc lang descriptions
      method description_opt (lang : lang) : string option = List.assoc_opt lang descriptions
      method aliases (lang : lang) : string list = List.assoc lang aliases
      end
    
  let truthy_claims (claims : Statement.t list) =
    match List.filter (fun (c : Statement.t) -> c.rank = Preferred) claims with
    | [] -> List.filter (fun (c : Statement.t) -> c.rank <> Deprecated) claims
    | preferred -> preferred

  class virtual claims_mixin ~(claims : (lang * Statement.t list) list) = object
    method all_statements : (propertyid * Statement.t list) list = claims
    method statements (p : propertyid) = match List.assoc_opt p claims with
      | Some cs -> cs
      | None -> []
    method all_truthy_statements : (propertyid * Statement.t list) list =
      List.map (fun (s, c) -> (s, truthy_claims c)) claims
    method truthy_statements (p : propertyid) = match List.assoc_opt p claims with
      | Some cs -> (truthy_claims cs) 
      | None -> []
  end

  let internal_entity_of_entities_string s : InternalJsonRep.entity =
    match InternalJsonRep.entities_of_string s with
    | {entities = (_, entity)::_;} -> entity
    | _ -> bad_json_data "Empty entities dict"

  module Item = struct
    type sitelink = {site: string; title: string; badges: string list; url : string option}

    class t
        ~(id : string)
        ~(entity_type : string)
        ~(labels : (lang * string) list)
        ~(descriptions : (lang * string) list)
        ~(aliases : (lang * string list) list)
        ~(statements : (propertyid * Statement.t list) list)
        ~(sitelinks : (string * sitelink) list)
        = object
      inherit basic_entity
        ~id: id
        ~entity_type: entity_type
        ~labels: labels
        ~descriptions: descriptions
        ~aliases: aliases
      inherit claims_mixin
        ~claims: statements
      method sitelinks : (string * sitelink) list = sitelinks
    end        
    
    let of_internal (i : InternalJsonRep.item) =
      let id = i.id in
      let entity_type = i.entity_type in
      let labels =
        List.map
          (fun (p, (lv : InternalJsonRep.langvalue)) -> (p, lv.value))
          i.labels in
      let descriptions =
        List.map
          (fun (p, (lv : InternalJsonRep.langvalue)) -> (p, lv.value))
          i.descriptions in
      let aliases =
        List.map
          (fun (p, (lvl : InternalJsonRep.langvalue list)) ->
            p,
            List.map
              (fun (lv : InternalJsonRep.langvalue) -> lv.value)
              lvl
          )
          i.aliases in
      let statements =
        List.map
          (fun (p, (stl : InternalJsonRep.statement list)) ->
            p,
            List.map
              (fun (st : InternalJsonRep.statement) -> Statement.of_internal st)
              stl
          )
          i.claims in
      let sitelinks = match i.sitelinks with
        | Some l -> (
          List.map (
            fun (s, (sl : InternalJsonRep.sitelink)) ->
              (s, {site = sl.site; title = sl.title; badges = sl.badges; url = sl.url})
              )
            l
          )
        | None -> []  in
      new t
        ~id:id
        ~entity_type:entity_type
        ~labels:labels
        ~descriptions:descriptions
        ~aliases:aliases
        ~statements:statements
        ~sitelinks:sitelinks
    
    
    let of_string s = s |> InternalJsonRep.item_of_string |> of_internal  

    let unpack_from_internal_entity : InternalJsonRep.entity -> InternalJsonRep.item = function
    | `Item i -> i
    | _ -> raise @@ Invalid_argument "expected entity of item type"

    let of_entities_string s = s |> internal_entity_of_entities_string
      |> unpack_from_internal_entity |> of_internal
    
  end

  module Property = struct 
    class t
        ~(id : string)
        ~(entity_type : string)
        ~(labels : (lang * string) list)
        ~(descriptions : (lang * string) list)
        ~(aliases : (lang * string list) list)
        ~(statements : (propertyid * Statement.t list) list)
        ~(datatype : string)
        = object
      inherit basic_entity
        ~id: id
        ~entity_type: entity_type
        ~labels: labels
        ~descriptions: descriptions
        ~aliases: aliases
      inherit claims_mixin
        ~claims: statements
      method datatype : string = datatype (* change this to be more expressive *)
    end

    let of_internal (i : InternalJsonRep.property) =
      let id = i.id in
      let entity_type = i.entity_type in
      let labels =
        List.map
          (fun (p, (lv : InternalJsonRep.langvalue)) -> (p, lv.value))
          i.labels in
      let descriptions =
        List.map
          (fun (p, (lv : InternalJsonRep.langvalue)) -> (p, lv.value))
          i.descriptions in
      let aliases =
        List.map
          (fun (p, (lvl : InternalJsonRep.langvalue list)) ->
            p,
            List.map
              (fun (lv : InternalJsonRep.langvalue) -> lv.value)
              lvl
          )
          i.aliases in
      let statements =
        List.map
          (fun (p, (stl : InternalJsonRep.statement list)) ->
            p,
            List.map
              (fun (st : InternalJsonRep.statement) -> Statement.of_internal st)
              stl
          )
          i.claims in
      let datatype = i.datatype in
      new t
        ~id
        ~entity_type
        ~labels
        ~descriptions
        ~aliases
        ~statements
        ~datatype

    let of_string s = s |> InternalJsonRep.property_of_string |> of_internal

    let unpack_from_internal_entity : InternalJsonRep.entity -> InternalJsonRep.property = function
    | `Property p -> p
    | _ -> raise @@ Invalid_argument "expected entity of property type"

    let of_entities_string s = s |> internal_entity_of_entities_string
      |> unpack_from_internal_entity |> of_internal
  end

  type t = Item of Item.t | Property of Property.t

  let of_internal : InternalJsonRep.entity -> t = function
  | `Item i -> Item (Item.of_internal i)
  | `Property p -> Property (Property.of_internal p)
  | _ -> raise Not_implemented

  let of_string s : t = s |> InternalJsonRep.entity_of_string |> of_internal
  
  let of_entities_string s : t = s |> internal_entity_of_entities_string |> of_internal

  

end
