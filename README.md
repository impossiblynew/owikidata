# owikidata - OCaml Wikidata
**WARNING - THIS LIBRARY IS IN ALPHA - EXPECT RANDOM BREAKING CHANGES**

An OCaml library (inspired by [qwikidata](https://github.com/kensho-technologies/qwikidata)) for parsing Wikidata JSON strings into more OCaml-friendly formats. It does not currently provide any faculties for retrieving Wikidata JSON strings.

## Installation
Clone the repository, then use opam to install:
```console
$ git clone https://github.com/impossiblynew/owikidata.git
$ opam install ./owikidata
```

## Example
Here's a simple example of this library in action, demonstrating a simple module for retrieving
Wikidata Entities from wikidata.org, and the benefits of Row Polymorphism.
```ocaml
(* example.ml *)
open Cohttp
open Cohttp_lwt_unix
open Lwt.Syntax

(* A simple module that retrieves data from wikidata.org, then turns it into an
OCaml object using the Wikidata library. *)
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

(* A simple function that makes use of row polymorphism to work on both Items
and Properties. *)
let string_of_entity lang e =
  Printf.sprintf "%s = %s: %s" e#id (e#label lang) (e#description lang)


let () = Lwt_main.run begin
  let id = Sys.argv.(1) in
  let lang = Sys.argv.(2) in
  let+ e = WikidataOrg.get_entity_from_api id in
  let entity_string = match e with
  | Item i -> string_of_entity lang i
  | Property p -> string_of_entity lang p in
  print_endline entity_string
end
```

Running
```console
$ ocamlfind opt -linkpkg -thread -package lwt.unix,cohttp-lwt-unix,wikidata example.ml
```
will produce a small command line program that can be used to get labels and descriptions of Wikidata Entities in a given language:
```console
$ ./a.out Q42 en
Q42 = Douglas Adams: English writer and humorist
$ ./a.out Q42 fr
Q42 = Douglas Adams: écrivain anglais de science-fiction
$ ./a.out P943 en
P943 = programmer: the programmer that wrote the piece of software
$ ./a.out P943 fr
P943 = programmeur: développeur d'un logiciel ou d'une oeuvre numérique comme un jeu vidéo
```


## Documentation
Documentation can be accessed from this repository's [Github Pages Site](https://impossiblynew.github.io/owikidata/wikidata/Wikidata/index.html).

