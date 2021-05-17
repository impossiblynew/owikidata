(*https://stackoverflow.com/a/53840784*)
let read_whole_file filename =
  let ch = open_in filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s


module Q42 = struct
  let q42_string = read_whole_file ("./testfiles/Q42.json")

  let id () =
    Alcotest.(check string) "ID" "Q42"
    ((Wikidata.Entity.Item.of_entities_string q42_string)#id)
  
  
  let label () =
    Alcotest.(check string) "Label" "Douglas Adams"
      (let q42 = Wikidata.Entity.Item.of_entities_string q42_string in q42#label "en")
  
  let label_exn () =
    Alcotest.check_raises "Label Exception" Not_found (fun () ->
      let q42 = Wikidata.Entity.Item.of_entities_string q42_string in
      let _ = q42#label "not real language" in ())
  
  let label_opt () =
    Alcotest.(check @@ option string) "Some" (Some "Douglas Adams") (
      let q42 = Wikidata.Entity.Item.of_entities_string q42_string in
      q42#label_opt "en");
    Alcotest.(check @@ option string) "None" (None) (
      let q42 = Wikidata.Entity.Item.of_entities_string q42_string in
      q42#label_opt "fake language") 
  let description () =
    Alcotest.(check string) "Description" "English writer and humorist"
    ((Wikidata.Entity.Item.of_entities_string q42_string)#description "en")

  let description_exn () =
    Alcotest.check_raises "Description exn" Not_found ( fun () ->
      let _ = (Wikidata.Entity.Item.of_entities_string q42_string)#description "fake lang" in 
      ())

  let description_opt () =
    Alcotest.(check @@ option string) "Some" (Some "English writer and humorist")
    ((Wikidata.Entity.Item.of_entities_string q42_string)#description_opt "en")

  let aliases () =
    Alcotest.(check @@ list string) "Aliases"
      ["Douglas Noel Adams"; "Douglas Noël Adams"; "Douglas N. Adams"]
      ((Wikidata.Entity.Item.of_entities_string q42_string)#aliases "en")
  
  let aliases_empty () =
    Alcotest.(check @@ list string) "Empty" []
      ((Wikidata.Entity.Item.of_entities_string q42_string)#aliases "fake lang")
    

  let get_property () =
    Alcotest.(check string) "Get property" "Q14623683" (
      let q42 = Wikidata.Entity.Item.of_entities_string q42_string in
      match (q42#truthy_statements "P40" |> List.hd) .mainsnak with
      | Wikidata.Snak.Value (Wikidata.Snak.Item {id; _}) -> id
      | _ -> raise Not_found
      )
  
  let get_property_truthy () =
    Alcotest.(check @@ list string) "Truthy P735" ["Q463035"] (
      let open Wikidata in
      let q42 = Entity.Item.of_entities_string q42_string in
      let truthy = q42#truthy_statements "P735" in
      List.map 
        (fun (s : Wikidata.Statement.t) -> match s.mainsnak with
          | Value (Item {id; _}) -> id
          | _ -> Alcotest.fail "Wrong data type")
        truthy
    )
  let get_property_not_truthy () =
    Alcotest.(check @@ list string) "Not Truthy P735" ["Q463035"; "Q19688263"] (
      let open Wikidata in
      let q42 = Entity.Item.of_entities_string q42_string in
      let truthy = q42#statements "P735" in
      List.map 
        (fun (s : Wikidata.Statement.t) -> match s.mainsnak with
          | Value (Item {id; _}) -> id
          | _ -> Alcotest.fail "Wrong data type")
        truthy
    )
end

module Q691283 = struct
  let s = read_whole_file "./testfiles/Q691283.json"

  let snak () =
    Alcotest.(check @@ float epsilon_float) "Get latitude" 52.208055555556 (
      let q = Wikidata.Entity.Item.of_entities_string s in
      match (q#truthy_statements "P625" |> List.hd).mainsnak with
      | Wikidata.Snak.(Value GlobeCoordinate {latitude; _}) -> latitude
      | _ -> raise Not_found  )
end

module Q1038788 = struct
  let s = read_whole_file "./testfiles/Q1038788.json"

  let label () =
    Alcotest.(check string) "Construct and get label" "Hyatt Regency walkway collapse"
    ((Wikidata.Entity.Item.of_string s)#label "en")
end

module Q2 = struct
  let s = read_whole_file "./testfiles/Q2.json"

  let label () =
    Alcotest.(check string) "Construct and get label" "Earth"
    ((Wikidata.Entity.Item.of_entities_string s)#label "en")
end

let make_file_test dir f =
  let test () = 
    let s = read_whole_file (dir ^ "/" ^ f) in
    let _ = Wikidata.Entity.Item.of_entities_string s in () in
  Alcotest.test_case f `Quick test

let automated_tests () =
  let auto_dir = "./testfiles/automated" in
  let files = Sys.readdir auto_dir in
  Array.to_list (Array.map (make_file_test auto_dir) files)


let () =
  let open Alcotest in
  run "Wikidata Tests" [
      "Q42 - Basic Tests", [
        test_case "ID" `Quick Q42.id;
        test_case "label" `Quick Q42.label;
        test_case "label exn" `Quick Q42.label_exn;
        test_case "label opt" `Quick Q42.label_opt;
        test_case "description" `Quick Q42.description;
        test_case "desc exn" `Quick Q42.description_exn;
        test_case "desc opt" `Quick Q42.description_opt;
        test_case "aliases" `Quick Q42.aliases;
        test_case "aliases empty" `Quick Q42.aliases_empty;
        ];
      "Q42 - Complex Tests", [
        test_case "get property" `Quick Q42.get_property;
        test_case "prop truthy" `Quick Q42.get_property_truthy;
        test_case "not truthy" `Quick Q42.get_property_not_truthy;
      ];
      "Q691283 - Complex Tests", [
        test_case "access snak" `Quick Q691283.snak;
      ];
      "Q1038788 - Basic Test in Dump Format", [
        test_case "label" `Quick Q1038788.label;
      ];
      "Q2 - Basic Test", [
        test_case "label" `Quick Q2.label;
      ];
      "Automated Construction Tests", automated_tests ()

  ]