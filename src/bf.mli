module type STATE =
  sig
    type t
    val increment : t -> t
    val decrement : t -> t
    val left : t -> t
    val right : t -> t
    val input : t -> t
    val output : t -> t
    val is_zero : t -> bool
  end
module ExampleState :
  sig
    type t = { left : int list; curr : int; right : int list; }
    val empty : t
    val increment : t -> t
    val decrement : t -> t
    val left : t -> t
    val right : t -> t
    val input : t -> t
    val output : t -> t
    val is_zero : t -> bool
  end
module type SYNTAX =
  sig
    type t
    val stop : t
    val inc : t -> t
    val dec : t -> t
    val left : t -> t
    val right : t -> t
    val input : t -> t
    val output : t -> t
    val loop : t -> t -> t
  end
module Syntax :
  sig
    type t =
        End
      | Inc of t
      | Dec of t
      | Left of t
      | Right of t
      | Input of t
      | Output of t
      | Loop of t * t
    val stop : t
    val inc : t -> t
    val dec : t -> t
    val left : t -> t
    val right : t -> t
    val input : t -> t
    val output : t -> t
    val loop : t -> t -> t
  end
val string_of_syntax : Syntax.t -> string
val transform_syntax : (module SYNTAX with type t = 'a) -> Syntax.t -> 'a
module RunnableSyntax :
  functor (State : STATE) ->
    sig
      type t
      val stop : t
      val inc : t -> t
      val dec : t -> t
      val left : t -> t
      val right : t -> t
      val input : t -> t
      val output : t -> t
      val loop : t -> t -> t
      val run : t -> State.t -> State.t
      val of_syntax : Syntax.t -> t
    end
val test : unit -> unit
