(lang dune 2.8.5)

(name wikidata)

(version 0.0.3)

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
  (atdgen :build)
  (atdgen-runtime
   (>= 2.2.1))
  (alcotest
   (and
    (>= 1.4.0)
    :with-test))
  (alcotest-lwt
   (and
    (>= 1.4.0)
    :with-test))
  (lwt_ppx
   (and
    (>= 2.0.2)
    :with-test))
  (bisect_ppx
   (and
    (>= 2.5.0)
    :with-test))
  (odoc :with-doc)))
