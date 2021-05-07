(* Auto-generated from "json_parsing.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type wikibase_entityid = {
  entity_type: string;
  id: string;
  numeric_id: int option
}

type wikibase_entityid_value = { value: wikibase_entityid }

type time = {
  time: string;
  timezone: int;
  before: int option;
  after: int option;
  precision: int;
  calendarmodel: string
}

type time_value = { value: time }

type string_value = { value: string }

type snaktype = [ `Value | `SomeValue | `NoValue ]

type quantity = {
  amount: string;
  upperBound: string option;
  lowerBound: string option;
  quantity_unit: string
}

type quantity_value = { value: quantity }

type number = Yojson.Safe.t

type monolingualtext = { language: string; text: string }

type monolingualtext_value = { value: monolingualtext }

type globecoordinate = {
  latitude: number;
  longitude: number;
  precision: number option;
  globe: string
}

type globecoordinate_value = { value: globecoordinate }

type datavalue = [
    `String of string_value
  | `Wikibase_EntityId of wikibase_entityid_value
  | `GlobeCoordinate of globecoordinate_value
  | `Quantity of quantity_value
  | `Time of time_value
  | `MonolingualText of monolingualtext_value
]

type snak = {
  snaktype: snaktype;
  property: string;
  datatype: string option;
  datavalue: datavalue option
}

type reference = {
  hash: string;
  snaks: (string * snak list) list;
  snaks_order: string list
}

type rank = [ `Preferred | `Normal | `Deprecated ]

type statement = {
  id: string;
  mainsnak: snak;
  entity_type: string;
  rank: rank;
  qualifiers: (string * snak list) list option;
  references: reference list option
}

type sitelink = {
  site: string;
  title: string;
  badges: string list;
  url: string option
}

type langvalue = { language: string; value: string }

type property = {
  id: string;
  entity_type: string;
  datatype: string;
  lastrevid: int;
  labels: (string * langvalue) list;
  descriptions: (string * langvalue) list;
  aliases: (string * langvalue list) list;
  claims: (string * statement list) list;
  modified: string option
}

type lexeme = {
  id: string;
  entity_type: string;
  lexical_category: string;
  language: string;
  claims: (string * statement list) list
}

type item = {
  id: string;
  entity_type: string;
  lastrevid: int;
  labels: (string * langvalue) list;
  descriptions: (string * langvalue) list;
  aliases: (string * langvalue list) list;
  claims: (string * statement list) list;
  sitelinks: (string * sitelink) list option;
  modified: string option
}

type entity = [ `Item of item | `Property of property | `Lexeme of lexeme ]

type entities = { entities: (string * entity) list }
