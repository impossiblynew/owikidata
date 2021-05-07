# owikidata - OCaml Wikidata
**WARNING - THIS LIBRARY IS IN ALPHA - EXPECT RANDOM BREAKING CHANGES**

An OCaml library for parsing Wikidata JSON strings into more OCaml-friendly formats. It does not currently provide any faculties for retrieving Wikidata JSON strings.

## Example
Here's a simple example of this library in action:
```ocaml
(* example.ml *)
open Cohttp
open Cohttp_lwt_unix
open Lwt.Infix

module WikidataOrg = struct
  let wikidata_base_url = "https://www.wikidata.org/wiki/Special:EntityData/"
  exception Bad_response_code of int

  let get_json_from_api ?(base_url=wikidata_base_url) id =
    let url = base_url ^ id ^ ".json" in
    Client.get (Uri.of_string url) >>= fun (resp, body) ->
      let code = resp |> Response.status |> Code.code_of_status in
      if code <> 200 then raise (Bad_response_code code)
      else body |> Cohttp_lwt.Body.to_string
  
  let entity_of_json_lwt x = Lwt.map Wikidata.Entity.of_entities_string x
  let get_entity id = id |> get_json_from_api |> entity_of_json_lwt
end

let label_desc_of_entity lang e = (e#label lang) ^ ": " ^ (e#description lang)

let label_desc_of_id lang id = Lwt.map (function
  | Wikidata.Entity.Item e -> label_desc_of_entity lang e
  | Wikidata.Entity.Property e -> label_desc_of_entity lang e)
  (WikidataOrg.get_entity id)

let () = Sys.argv.(1) |> (label_desc_of_id Sys.argv.(2)) |> Lwt_main.run |> print_endline
```

Running
```console
$ ocamlfind opt -linkpkg -thread -package lwt.unix,cohttp-lwt-unix,wikidata example.ml
```
will produce a small command line program that can be used to get labels and descriptions of Wikidata Entities in a given language:
```console
$ ./a.out Q42 en
Douglas Adams: English writer and humorist
$ ./a.out Q42 fr
Douglas Adams: écrivain anglais de science-fiction
$ ./a.out P943 en
programmer: the programmer that wrote the piece of software
$ ./a.out P943 fr
programmeur: développeur d'un logiciel ou d'une oeuvre numérique comme un jeu vidéo
```


## Documentation
Documentation can be accessed from this repository's [Github Pages Site](https://impossiblynew.github.io/owikidata/wikidata/Wikidata/index.html).

