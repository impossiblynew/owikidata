(* Auto-generated from "json_parsing.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type wikibase_entityid = Json_parsing_t.wikibase_entityid = {
  entity_type: string;
  id: string;
  numeric_id: int option
}

type wikibase_entityid_value = Json_parsing_t.wikibase_entityid_value = {
  value: wikibase_entityid
}

type time = Json_parsing_t.time = {
  time: string;
  timezone: int;
  before: int option;
  after: int option;
  precision: int;
  calendarmodel: string
}

type time_value = Json_parsing_t.time_value = { value: time }

type string_value = Json_parsing_t.string_value = { value: string }

type snaktype = Json_parsing_t.snaktype

type quantity = Json_parsing_t.quantity = {
  amount: string;
  upperBound: string option;
  lowerBound: string option;
  quantity_unit: string
}

type quantity_value = Json_parsing_t.quantity_value = { value: quantity }

type number = Yojson.Safe.t

type monolingualtext = Json_parsing_t.monolingualtext = {
  language: string;
  text: string
}

type monolingualtext_value = Json_parsing_t.monolingualtext_value = {
  value: monolingualtext
}

type globecoordinate = Json_parsing_t.globecoordinate = {
  latitude: number;
  longitude: number;
  precision: number option;
  globe: string
}

type globecoordinate_value = Json_parsing_t.globecoordinate_value = {
  value: globecoordinate
}

type datavalue = Json_parsing_t.datavalue

type snak = Json_parsing_t.snak = {
  snaktype: snaktype;
  property: string;
  datatype: string option;
  datavalue: datavalue option
}

type reference = Json_parsing_t.reference = {
  hash: string;
  snaks: (string * snak list) list;
  snaks_order: string list
}

type rank = Json_parsing_t.rank

type statement = Json_parsing_t.statement = {
  id: string;
  mainsnak: snak;
  entity_type: string;
  rank: rank;
  qualifiers: (string * snak list) list option;
  references: reference list option
}

type sitelink = Json_parsing_t.sitelink = {
  site: string;
  title: string;
  badges: string list;
  url: string option
}

type langvalue = Json_parsing_t.langvalue = {
  language: string;
  value: string
}

type property = Json_parsing_t.property = {
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

type lexeme = Json_parsing_t.lexeme = {
  id: string;
  entity_type: string;
  lexical_category: string;
  language: string;
  claims: (string * statement list) list
}

type item = Json_parsing_t.item = {
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

type entity = Json_parsing_t.entity

type entities = Json_parsing_t.entities = {
  entities: (string * entity) list
}

val write_wikibase_entityid :
  Bi_outbuf.t -> wikibase_entityid -> unit
  (** Output a JSON value of type {!wikibase_entityid}. *)

val string_of_wikibase_entityid :
  ?len:int -> wikibase_entityid -> string
  (** Serialize a value of type {!wikibase_entityid}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_wikibase_entityid :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> wikibase_entityid
  (** Input JSON data of type {!wikibase_entityid}. *)

val wikibase_entityid_of_string :
  string -> wikibase_entityid
  (** Deserialize JSON data of type {!wikibase_entityid}. *)

val write_wikibase_entityid_value :
  Bi_outbuf.t -> wikibase_entityid_value -> unit
  (** Output a JSON value of type {!wikibase_entityid_value}. *)

val string_of_wikibase_entityid_value :
  ?len:int -> wikibase_entityid_value -> string
  (** Serialize a value of type {!wikibase_entityid_value}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_wikibase_entityid_value :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> wikibase_entityid_value
  (** Input JSON data of type {!wikibase_entityid_value}. *)

val wikibase_entityid_value_of_string :
  string -> wikibase_entityid_value
  (** Deserialize JSON data of type {!wikibase_entityid_value}. *)

val write_time :
  Bi_outbuf.t -> time -> unit
  (** Output a JSON value of type {!time}. *)

val string_of_time :
  ?len:int -> time -> string
  (** Serialize a value of type {!time}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_time :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> time
  (** Input JSON data of type {!time}. *)

val time_of_string :
  string -> time
  (** Deserialize JSON data of type {!time}. *)

val write_time_value :
  Bi_outbuf.t -> time_value -> unit
  (** Output a JSON value of type {!time_value}. *)

val string_of_time_value :
  ?len:int -> time_value -> string
  (** Serialize a value of type {!time_value}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_time_value :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> time_value
  (** Input JSON data of type {!time_value}. *)

val time_value_of_string :
  string -> time_value
  (** Deserialize JSON data of type {!time_value}. *)

val write_string_value :
  Bi_outbuf.t -> string_value -> unit
  (** Output a JSON value of type {!string_value}. *)

val string_of_string_value :
  ?len:int -> string_value -> string
  (** Serialize a value of type {!string_value}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_string_value :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> string_value
  (** Input JSON data of type {!string_value}. *)

val string_value_of_string :
  string -> string_value
  (** Deserialize JSON data of type {!string_value}. *)

val write_snaktype :
  Bi_outbuf.t -> snaktype -> unit
  (** Output a JSON value of type {!snaktype}. *)

val string_of_snaktype :
  ?len:int -> snaktype -> string
  (** Serialize a value of type {!snaktype}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_snaktype :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> snaktype
  (** Input JSON data of type {!snaktype}. *)

val snaktype_of_string :
  string -> snaktype
  (** Deserialize JSON data of type {!snaktype}. *)

val write_quantity :
  Bi_outbuf.t -> quantity -> unit
  (** Output a JSON value of type {!quantity}. *)

val string_of_quantity :
  ?len:int -> quantity -> string
  (** Serialize a value of type {!quantity}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_quantity :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> quantity
  (** Input JSON data of type {!quantity}. *)

val quantity_of_string :
  string -> quantity
  (** Deserialize JSON data of type {!quantity}. *)

val write_quantity_value :
  Bi_outbuf.t -> quantity_value -> unit
  (** Output a JSON value of type {!quantity_value}. *)

val string_of_quantity_value :
  ?len:int -> quantity_value -> string
  (** Serialize a value of type {!quantity_value}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_quantity_value :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> quantity_value
  (** Input JSON data of type {!quantity_value}. *)

val quantity_value_of_string :
  string -> quantity_value
  (** Deserialize JSON data of type {!quantity_value}. *)

val write_number :
  Bi_outbuf.t -> number -> unit
  (** Output a JSON value of type {!number}. *)

val string_of_number :
  ?len:int -> number -> string
  (** Serialize a value of type {!number}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_number :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> number
  (** Input JSON data of type {!number}. *)

val number_of_string :
  string -> number
  (** Deserialize JSON data of type {!number}. *)

val write_monolingualtext :
  Bi_outbuf.t -> monolingualtext -> unit
  (** Output a JSON value of type {!monolingualtext}. *)

val string_of_monolingualtext :
  ?len:int -> monolingualtext -> string
  (** Serialize a value of type {!monolingualtext}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_monolingualtext :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> monolingualtext
  (** Input JSON data of type {!monolingualtext}. *)

val monolingualtext_of_string :
  string -> monolingualtext
  (** Deserialize JSON data of type {!monolingualtext}. *)

val write_monolingualtext_value :
  Bi_outbuf.t -> monolingualtext_value -> unit
  (** Output a JSON value of type {!monolingualtext_value}. *)

val string_of_monolingualtext_value :
  ?len:int -> monolingualtext_value -> string
  (** Serialize a value of type {!monolingualtext_value}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_monolingualtext_value :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> monolingualtext_value
  (** Input JSON data of type {!monolingualtext_value}. *)

val monolingualtext_value_of_string :
  string -> monolingualtext_value
  (** Deserialize JSON data of type {!monolingualtext_value}. *)

val write_globecoordinate :
  Bi_outbuf.t -> globecoordinate -> unit
  (** Output a JSON value of type {!globecoordinate}. *)

val string_of_globecoordinate :
  ?len:int -> globecoordinate -> string
  (** Serialize a value of type {!globecoordinate}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_globecoordinate :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> globecoordinate
  (** Input JSON data of type {!globecoordinate}. *)

val globecoordinate_of_string :
  string -> globecoordinate
  (** Deserialize JSON data of type {!globecoordinate}. *)

val write_globecoordinate_value :
  Bi_outbuf.t -> globecoordinate_value -> unit
  (** Output a JSON value of type {!globecoordinate_value}. *)

val string_of_globecoordinate_value :
  ?len:int -> globecoordinate_value -> string
  (** Serialize a value of type {!globecoordinate_value}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_globecoordinate_value :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> globecoordinate_value
  (** Input JSON data of type {!globecoordinate_value}. *)

val globecoordinate_value_of_string :
  string -> globecoordinate_value
  (** Deserialize JSON data of type {!globecoordinate_value}. *)

val write_datavalue :
  Bi_outbuf.t -> datavalue -> unit
  (** Output a JSON value of type {!datavalue}. *)

val string_of_datavalue :
  ?len:int -> datavalue -> string
  (** Serialize a value of type {!datavalue}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_datavalue :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> datavalue
  (** Input JSON data of type {!datavalue}. *)

val datavalue_of_string :
  string -> datavalue
  (** Deserialize JSON data of type {!datavalue}. *)

val write_snak :
  Bi_outbuf.t -> snak -> unit
  (** Output a JSON value of type {!snak}. *)

val string_of_snak :
  ?len:int -> snak -> string
  (** Serialize a value of type {!snak}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_snak :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> snak
  (** Input JSON data of type {!snak}. *)

val snak_of_string :
  string -> snak
  (** Deserialize JSON data of type {!snak}. *)

val write_reference :
  Bi_outbuf.t -> reference -> unit
  (** Output a JSON value of type {!reference}. *)

val string_of_reference :
  ?len:int -> reference -> string
  (** Serialize a value of type {!reference}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_reference :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> reference
  (** Input JSON data of type {!reference}. *)

val reference_of_string :
  string -> reference
  (** Deserialize JSON data of type {!reference}. *)

val write_rank :
  Bi_outbuf.t -> rank -> unit
  (** Output a JSON value of type {!rank}. *)

val string_of_rank :
  ?len:int -> rank -> string
  (** Serialize a value of type {!rank}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_rank :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> rank
  (** Input JSON data of type {!rank}. *)

val rank_of_string :
  string -> rank
  (** Deserialize JSON data of type {!rank}. *)

val write_statement :
  Bi_outbuf.t -> statement -> unit
  (** Output a JSON value of type {!statement}. *)

val string_of_statement :
  ?len:int -> statement -> string
  (** Serialize a value of type {!statement}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_statement :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> statement
  (** Input JSON data of type {!statement}. *)

val statement_of_string :
  string -> statement
  (** Deserialize JSON data of type {!statement}. *)

val write_sitelink :
  Bi_outbuf.t -> sitelink -> unit
  (** Output a JSON value of type {!sitelink}. *)

val string_of_sitelink :
  ?len:int -> sitelink -> string
  (** Serialize a value of type {!sitelink}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_sitelink :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> sitelink
  (** Input JSON data of type {!sitelink}. *)

val sitelink_of_string :
  string -> sitelink
  (** Deserialize JSON data of type {!sitelink}. *)

val write_langvalue :
  Bi_outbuf.t -> langvalue -> unit
  (** Output a JSON value of type {!langvalue}. *)

val string_of_langvalue :
  ?len:int -> langvalue -> string
  (** Serialize a value of type {!langvalue}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_langvalue :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> langvalue
  (** Input JSON data of type {!langvalue}. *)

val langvalue_of_string :
  string -> langvalue
  (** Deserialize JSON data of type {!langvalue}. *)

val write_property :
  Bi_outbuf.t -> property -> unit
  (** Output a JSON value of type {!property}. *)

val string_of_property :
  ?len:int -> property -> string
  (** Serialize a value of type {!property}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_property :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> property
  (** Input JSON data of type {!property}. *)

val property_of_string :
  string -> property
  (** Deserialize JSON data of type {!property}. *)

val write_lexeme :
  Bi_outbuf.t -> lexeme -> unit
  (** Output a JSON value of type {!lexeme}. *)

val string_of_lexeme :
  ?len:int -> lexeme -> string
  (** Serialize a value of type {!lexeme}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_lexeme :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> lexeme
  (** Input JSON data of type {!lexeme}. *)

val lexeme_of_string :
  string -> lexeme
  (** Deserialize JSON data of type {!lexeme}. *)

val write_item :
  Bi_outbuf.t -> item -> unit
  (** Output a JSON value of type {!item}. *)

val string_of_item :
  ?len:int -> item -> string
  (** Serialize a value of type {!item}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_item :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> item
  (** Input JSON data of type {!item}. *)

val item_of_string :
  string -> item
  (** Deserialize JSON data of type {!item}. *)

val write_entity :
  Bi_outbuf.t -> entity -> unit
  (** Output a JSON value of type {!entity}. *)

val string_of_entity :
  ?len:int -> entity -> string
  (** Serialize a value of type {!entity}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_entity :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> entity
  (** Input JSON data of type {!entity}. *)

val entity_of_string :
  string -> entity
  (** Deserialize JSON data of type {!entity}. *)

val write_entities :
  Bi_outbuf.t -> entities -> unit
  (** Output a JSON value of type {!entities}. *)

val string_of_entities :
  ?len:int -> entities -> string
  (** Serialize a value of type {!entities}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_entities :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> entities
  (** Input JSON data of type {!entities}. *)

val entities_of_string :
  string -> entities
  (** Deserialize JSON data of type {!entities}. *)

