(lang dune 2.8.5)

(name wikidata)

(version 0.0.1)

(generate_opam_files true)

(license MIT)

(authors "Impossibly New")

(maintainers "newlyimpossible@gmail.com")

(package
 (name wikidata)
 (synopsis "Library for parsing Wikidata JSON")
 (description
  "Provides functions for converting Wikidata JSON strings\n into objects and datatypes that represent Wikidata Entities in an OCaml-friendly\n format.")
 (homepage "https://github.com/impossiblynew/owikidata")
 (bug_reports "https://github.com/impossiblynew/owikidata/issues")
 (depends
  (ocaml
   (>= 4.11.1))
  (cohttp-lwt-unix
   (and
    (>= 4.0.0)
    :with-test))
  (tls
   (and
    (>= 0.13.0)
    :with-test))
  (atdgen
   (and
    (>= 2.2.1)
    :build))
  (atdgen-runtime
   (>= 2.2.1))
  (alcotest
   (and
    (>= 1.4.0)
    :with-test))
  (odoc
   (and
    (>= 1.5.2)
    :with-doc))))
