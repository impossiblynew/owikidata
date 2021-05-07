open Cohttp
open Cohttp_lwt_unix
open Lwt.Syntax

module WikidataOrg = struct
  exception Bad_response_code of int

  let wikidata_base_url = "https://www.wikidata.org/wiki/Special:EntityData/"

  (* Retrieves a JSON string from Wikidata's Linked Data Interface *)
  let get_string_from_api ?(base_url=wikidata_base_url) id =
    let uri = Uri.of_string (base_url ^ id ^ ".json") in
    let* resp, body = Client.get uri in
    let code = resp |> Response.status |> Code.code_of_status in
    if code <> 200 then raise (Bad_response_code code)
    else body |> Cohttp_lwt.Body.to_string
  
  (* Takes a JSON string of entities retrieved from Wikidata's Linked Data Interface
  and converts it to a Wikidata.Entity.t using the .of_entities_string function *)
  let get_entity_from_api ?(base_url=wikidata_base_url) id =
    let+ s = get_string_from_api ~base_url:base_url id in
    Wikidata.Entity.of_entities_string s
end


let test_q42 _ () =
  let+ e = WikidataOrg.get_entity_from_api "Q42" in
  let do_check e = Alcotest.(check string) "label check" "Douglas Adams" (e#label "en") in
  match e with | Item e -> do_check e | Property e -> do_check e

let make_entity_parse_test id =
  let new_test _ () =
    try%lwt let+ e = WikidataOrg.get_entity_from_api id in
    let _ = match e with
      | Item i -> i#id
      | Property p -> p#id in ()
    with WikidataOrg.Bad_response_code 404 -> Lwt.return () in
  Alcotest_lwt.test_case id `Slow new_test

let id_from_to prefix u v =
  let rec aux i (acc : string list) =
    if i <= u then acc
    else aux (i - 1) ((prefix ^ (string_of_int i))::acc) in
  aux v []


let () =
  Lwt_main.run @@ Alcotest_lwt.run "Online Tests" [
    "Q42", [
      Alcotest_lwt.test_case "get_label" `Slow test_q42
    ];
    "many Items",
    List.map make_entity_parse_test (id_from_to "Q" 0 100);
    "many Properties",
    List.map make_entity_parse_test (id_from_to "Q" 100 200)
  ]