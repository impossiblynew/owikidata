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
  
  let description () =
    Alcotest.(check string) "Description" "English writer and humorist"
    ((Wikidata.Entity.Item.of_entities_string q42_string)#description "en")

  let aliases () =
    Alcotest.(check @@ list string) "Aliases"
      ["Douglas Noel Adams"; "Douglas Noël Adams"; "Douglas N. Adams"]
      ((Wikidata.Entity.Item.of_entities_string q42_string)#aliases "en")

  let get_property () =
    Alcotest.(check string) "Get property" "Q14623683" (
      let q42 = Wikidata.Entity.Item.of_entities_string q42_string in
      match (q42#truthy_statements "P40" |> List.hd) .mainsnak with
      | Wikidata.Snak.Value (Wikidata.Snak.Item {id; _}) -> id
      | _ -> raise Not_found
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

let make_file_test f =
  let test () = 
    let s = read_whole_file f in
    let _ = Wikidata.Entity.Item.of_entities_string s in () in
  Alcotest.test_case f `Quick test

let automated_tests () =
  let auto_dir = "./testfiles/automated/" in
  let files = Sys.readdir auto_dir in
  let files = Array.map (fun f -> auto_dir ^ f) files in
  Array.to_list (Array.map make_file_test files)


let () =
  let open Alcotest in
  run "Wikidata Tests" [
      "Q42 - Basic Tests", [
        test_case "ID" `Quick Q42.id;
        test_case "label" `Quick Q42.label;
        test_case "description" `Quick Q42.description;
        test_case "aliases" `Quick Q42.aliases;
        ];
      "Q42 - Complex Tests", [
        test_case "get property" `Quick Q42.get_property;
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