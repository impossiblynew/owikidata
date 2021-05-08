

type propertyid = string
(** Used for strings that contain Wikidata Property IDs, like ["P69"]. *)

type lang = string
(** Used for strings that contain {{: https://www.wikidata.org/wiki/Help:Wikimedia_language_codes/lists/all}
Wikimedia language codes}. *)

exception Bad_json_data of string
(** Called when the json input is missing some field that was expected. The
string describes what exactly is missing *)

exception Not_implemented
(** Called when using a feature that is not implemented. Currently, this is only
raised when attempting to parse a Lexeme, Form, or Sense. *)


(** Represents {{: https://www.wikidata.org/wiki/Wikidata:Glossary#Snak} Wikidata Snaks}.*)
module Snak :
  sig

    (** {1:valuetypes Value Types}*)
    (** The following types represent value types according to
    {{: https://www.wikidata.org/wiki/Special:ListDatatypes} this list}. Note
    that these represent the type that the value corresponding to the data is
    returned in, not the way that the data should be interpreted. *)

    type wikibase_entityid = {
      entity_type : string;
      id : string;
      numeric_id : int option;
    }
    (** Represents a Wikibase entity id *)

    type globecoordinate = {
      latitude : float;
      longitude : float;
      precision : float option;
      globe : string;
    }
    (** Represents a Globe coordinate*)

    type quantity = {
      amount : float;
      upper_bound : float option;
      lower_bound : float option;
      quantity_unit : string;
    }
    (** Represents a Quantity *)

    type time = {
      time : string;
      timezone : int;
      before : int option;
      after : int option;
      calendarmodel : string;
      precision : int;
    }
    (** Represents a Time *)

    type monolingualtext = { language : string; text : string; }
    (** Represents Monolingual text *)

    (** {1:datatypes Data Types} *)

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
      | Sense of wikibase_entityid (** *)
    (** This type represents a {i data type} according to
    {{: https://www.wikidata.org/wiki/Help:Data_type} this page}. Data types on
    Wikidata represent the way that the data should be interpreted, not the
    format the data is returned in. Note that each variant data type has a
    corresponding {i {{!section:valuetypes} value type}}, which represents the
    form the data will be returned in. For example, both {!constructor:MusicalNotation}
    and {!constructor:MathematicalExpression} contain a simple [string], and {!constructor:Item}
    and {!constructor:Property} both are represented by a {!type:wikibase_entityid}.*)

    (** {1:snaks Snaks}*)

    type t = 
      | Value of data
        (** A snak with a known value [data]. *)
      | SomeValue
        (** A snak with some unknown value. *)
      | NoValue
        (** A snak representing an explicit, intentional lack of value.*)
    (** This represents a
    {{: https://www.wikidata.org/wiki/Wikidata:Glossary#Snak} Wikidata Snak}.
    {!constructor:Value} represents a known value. {!constructor:SomeValue} represents
    an unknown but extent value, like William Shakespeare's date of birth. {!constructor:NoValue}
    represents an explicitly empty value, like the children of Elizabeth I of England, 
    who had no children.*)

    (** {1:conversion Conversion}*)

    val of_string : string -> t
    (** Takes a json string representing a Wikidata snak in the format described
    {{: https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html#json_snaks}
    here} and returns the snak in type {!type:t}.*)

  end

(** Represents {{: https://www.wikidata.org/wiki/Wikidata:Glossary#Statement} Wikidata
Statements}.*)
module Statement :
  sig

    (** {1:rank Rank }*)

    type rank =
      | Preferred (** Assigned to the statement that best represents the consensus. *)
      | Normal (** Assigned to all statements by default. *)
      | Deprecated (** Assigned to statements known to contain errors. *)
    (** Represents the rank of a Wikidata Statement. For more information, please visit
    {{: https://www.wikidata.org/wiki/Help:Ranking} the Wikidata Help page for Rankings}.*)

    (** {2:truthiness "Truthiness"}
    
    While not defined in the official glossary, in Wikidata terminology, {e truthiness}
    is a property of Statements, defined by having the highest rank (that isn't
    deprecated) for any Statement for a given Property. For example, if an Item
    [Q] has two Preferred, one Normal, and one Deprecated Statement for the Property
    [PX], then the two Preferred Statements are considered {e truthy}. If that same
    Item has three Preferred Statements for the property [PY], then all three are
    considered truthy. And if property [PZ] of that same item has ten Statements,
    all Deprecated, then none are considered truthy.*)

    (** {1:references References}*)

    type reference = {
      hash : string; (** Hash that identifies each reference. *)
      snaks : (propertyid * Snak.t list) list; (** Associative list between Property
      IDs and Snaks. *)
      snaks_order : propertyid list; (** Order in which the snaks in {!field:snaks}
      should be logically displayed. *)
    }
    (** Represents the provenance/authority information for the main Snak and Qualifiers
    of a Statement. This information is stored as properties associated with Snaks. 
    This closely follows the representation of references in the original JSON as
    described in {{: https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html#json_references}
    the Wikibase JSON specifications}.*)

    (** {1:statements Statements}*)

    type t = {
      id : string; (** Identifier of the statement. *)
      rank : rank; (** Rank of the statement. *)
      mainsnak : Snak.t;
        (** The main Snak (or primary piece of data) this Statement contains. *)
      qualifiers : (propertyid * Snak.t list) list;
        (** The qualifiers of this statement, which add additional context to the
        statement, represented as an association list between Property IDs and lists
        of Snaks. *)
      references : reference list;
        (** List of references for this statement.*)
    }
    (** Represents {{: https://www.wikidata.org/wiki/Wikidata:Glossary#Statement}
    Wikidata Statements}. *)


    
    (** {1:conversions Conversions }*)

    val of_string : string -> t
    (** Converts a JSON string representing a statement as described in the
    {{: https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html#json_statements}
    Wikibase JSON Specifications} to a {!type:t}. *)
  end

(** Represents {{: https://www.wikidata.org/wiki/Wikidata:Glossary#Entity} Wikidata Entities}. *)
module Entity :
  sig
    (** {i Please note that currently only Items and Properties are supported.}

    {1 Rationale}

    Unlike most other Wikidata things in this library, Entities are represented
    by {e objects} rather than records. This is because many Entities share fields,
    like how Items ({!type:Item.t}) and Properties ({!type:Property.t}) both have
    [id]s, [label]s, [entity_type]s, [descriptions], [aliases], and [claims].
    
    Records are not polymorphic, and so were this library to use record types, code
    that uses only these shared fields would have to be duplicated to work on both
    Items and Properties.

    By using objects, through the magic of {{: https://dev.realworldocaml.org/objects.html#elisions-are-polymorphic}
    row polymorphism}, we can write code that operates on any object with compatible
    methods. For example, the following function can be run on both {!type:Item.t}s
    and {!type:Property.t}s:
    {[
      let label_and_description lang entity : string * string =
        (
          entity#label lang,
          entity#description lang
        )
    ]}
    Were we to use record types for Items and Properties, this function would require
    pattern matching and then duplicating the code to work on both Items and Properties.

      *)
      (* FIXME: test this works*)
    
    (** {2 Items}*)

    (** Represents {{: https://www.wikidata.org/wiki/Wikidata:Glossary#Item} Wikidata Items}. *)
    module Item :
      sig
      
      (** {1:sitelinks Sitelinks}*)

        type sitelink = {
          site : string;
          title : string;
          badges : string list;
          url : string option;
        }
        (** Links to the corresponding Wikipedia articles for this item, closely
        following the representation of sitelinks in the original JSON as specified
        in {{: https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html#json_sitelinks}
        the Wikibase JSON specifications}.*)

        (** {1:items Items} *)

        type t = <
            id : string;
            entity_type : string;
            label : lang -> string;
            aliases : lang -> string list;
            description : lang -> string;
            all_statements : (propertyid * Statement.t list) list;
            statements : propertyid -> Statement.t list;
            all_truthy_statements : (propertyid * Statement.t list) list;
            truthy_statements : propertyid -> Statement.t list;
            sitelinks : (string * sitelink) list;
          >
          (** Represents Wikidata Items.
          {ul 
          {- [ id : string ]
          
          Returns the {{: https://www.wikidata.org/wiki/Wikidata:Glossary#QID} QID} 
          of the item.}

          {- [ entity_type : string ]

          Returns the entry for [type] in the {{: https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html#json_structure}
          original json.} For Items, should always return ["item"]}

          {- [ label : lang -> string ]

          Given a {{: https://www.wikidata.org/wiki/Help:Wikimedia_language_codes/lists/all}
          Wikidata language code}, returns the label of the Item in that language.}

          {- [ aliases : lang -> string list ]

          Given a {{: https://www.wikidata.org/wiki/Help:Wikimedia_language_codes/lists/all}
          Wikidata language code}, returns a list of aliases for the Item in that
          language.}

          {- [ description : lang -> string ]

          Given a {{: https://www.wikidata.org/wiki/Help:Wikimedia_language_codes/lists/all}
          Wikidata language code}, returns the description for the Item in that
          language.}

          {- [ all_statements : (propertyid * Statement.t list) list ]
          
          Returns all Statements about this Item in an associative list
          between Property IDs and their corresponding Statements.}

          {- [ statements : propertyid -> Statement.t list ]
          
          Given a Property ID, returns the list of Statements corresponding
          to that Property for this Item. If that Property ID isn't present, returns
          an empty list.}

          {- [ all_truthy_statements : (propertyid * Statement.t list) list ]
          
          Returns all {{!section:Statement.truthiness} "truthy"} Statements about this Item in an associative list
          between Property IDs and their corresponding Statements.}

          {- [ truthy_statements : propertyid -> Statement.t list ]

          Given a Property ID, returns the list of {{!section:Statement.truthiness} "truthy"} Statements corresponding
          to that Property for this Item. If that Property ID isn't present or there
          are none, returns an empty list. }

          {- [ sitelinks : (string * sitelink) list ]
          
          Returns an associative list between Wikipedia language site identifiers and
          sitelinks. }
          }
          *)
      (*FIXME: should explain what it throws otherwise*)

        (** {1:conversions Conversions}*)

        val of_string : string -> t
        (** Turns a json string representing an Item (as described in the
        {{: https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html#json_structure}
        Wikibase JSON specification}) into a {!type:t}.*)

        val of_entities_string : string -> t
        (** Returns the first entity in a JSON string representing a group of entities
        as a {!type:t}. This is provided as a convenience function, as this is the
        format that requests to [https://wikidata.org/wiki/Special:EntityData/{ID}.json] 
        (where [ID] is a Wikidata Entity ID) are returned in. *)
      end
    
    (** {2 Properties} *)
    
    (** Represents {{: https://www.wikidata.org/wiki/Wikidata:Glossary#Property} Wikidata Properties}. *)
    module Property :
      sig
        class t :
              id:lang ->
              entity_type:lang ->
              labels:(lang * lang) list ->
              descriptions:(lang * lang) list ->
              aliases:(lang * lang list) list ->
              statements:(lang * Statement.t list) list ->
              datatype:lang ->
            object
              method id : string
              (** Returns the {{: https://www.wikidata.org/wiki/Wikidata:Identifiers}
              Property ID} of the Property. *)

              method entity_type : string
              (**  Returns the entry for [type] in the
              {{: https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html#json_structure}
              original json.} For Properties, should always return ["property"]*)

              method datatype : string
              (** *)

              method label : lang -> string
              (** Given a {{: https://www.wikidata.org/wiki/Help:Wikimedia_language_codes/lists/all}
              Wikidata language code}, returns the label of the Property in that
              language.*)

              method aliases : lang -> string list
              (** Given a {{: https://www.wikidata.org/wiki/Help:Wikimedia_language_codes/lists/all}
              Wikidata language code}, returns a list of aliases for the Property
              in that language.*)

              method description : lang -> string
              (** Given a {{: https://www.wikidata.org/wiki/Help:Wikimedia_language_codes/lists/all}
              Wikidata language code}, returns the description for the Property
              in that language.*)

              method all_statements : (propertyid * Statement.t list) list
              (** Returns all Statements about this Property in an associative list
              between Property IDs and their corresponding Statements.*)

              method statements : propertyid -> Statement.t list
              (** Given a Property ID, returns the list of Statements corresponding
              to that Property for this Property. If that Property ID isn't present,
              returns an empty list.*)

              method all_truthy_statements : (propertyid * Statement.t list) list
              (** Returns all {{!section:Statement.truthiness} "truthy"} Statements
              about this Property in an associative list between Property IDs and
              their corresponding Statements.*)
              
              method truthy_statements : propertyid -> Statement.t list
              (** Given a Property ID, returns the list of {{!section:Statement.truthiness}
              "truthy"} Statements corresponding to that Property for this Property.
              If that Property ID isn't present or there are none, returns an empty
              list.*)
            end
          (** Represents Wikidata Properties. *)
        
        (** {1:conversions Conversions}*)

        val of_string : string -> t
        (** Turns a json string representing a Property (as described in the
        {{: https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html#json_structure}
        Wikibase JSON specification}) into a {!type:t}. *)

        val of_entities_string : string -> t
        (** Returns the first entity in a JSON string representing a group of entities
        as a {!type:t}. This is provided as a convenience function, as this is the
        format that requests to [https://wikidata.org/wiki/Special:EntityData/{ID}.json] 
        (where [ID] is a Wikidata Entity ID) are returned in. *)

      end
    
    (** {1 Entities} 
    
    In this section, entities are represented as a variant type between different
    types of entities (like {!type:Item.t}s and {!type:Property.t}s) rather than
    as an object that is a subtype of both. The reason is that OCaml's object system
    lacks {{:https://dev.realworldocaml.org/objects.html#narrowing} narrowing}.
    As such, were we to return a mutual subtype of all entity types, methods that
    are not shared between those entity types would become inaccessible.*)

    type t =
      | Item of Item.t (** Represents a Wikidata Item. *)
      | Property of Property.t (** Represents a Wikidata Property. *)
    (** A variant type of all supported Entity types. *)

    (** {2:conversions Conversions}*)

    val of_string : string -> t
    (** Turns a json string representing some Entity (as described in the
    {{: https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html#json_structure}
    Wikibase JSON specification}) into a {!type:t}. *)

    val of_entities_string : string -> t
    (** Returns the first entity in a JSON string representing a group of entities
    as a {!type:t}. This is provided as a convenience function, as this is the
    format that requests to [https://wikidata.org/wiki/Special:EntityData/{ID}.json] 
    (where [ID] is a Wikidata Entity ID) are returned in. *)
  end