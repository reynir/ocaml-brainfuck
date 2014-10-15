(* State *)

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

module ExampleState =
  struct
    type t = {
      left : int list;
      curr : int;
      right : int list
    }
    let empty = { left = []; curr = 0; right = [] }

    let increment s = { s with curr = s.curr + 1 }
    and decrement s = { s with curr = s.curr - 1 }
    and left { left; curr; right } =
      match left with
      | new_curr :: new_left ->
         { left = new_left;
           curr = new_curr;
           right = curr :: right }
      | [] ->
         { left = [];
           curr = 0;
           right = curr :: right }
    and right { left; curr; right } =
      match right with
      | new_curr :: new_right ->
         { left = curr :: left;
           curr = new_curr;
           right = new_right }
      | [] ->
         { left = curr :: left;
           curr = 0;
           right = [] }
    and input s =
      let curr = try int_of_char (input_char stdin)
                  with End_of_file -> -1
      in { s with curr }
    and output ({ curr; _ } as s) =
      print_char (char_of_int curr);
      s
    and is_zero { curr; _ } =
      curr = 0
  end

(* Syntax *)

module type SYNTAX =
  sig
    type t
    val bf_end : t
    val bf_inc : t -> t
    val bf_dec : t -> t
    val bf_left : t -> t
    val bf_right : t -> t
    val bf_input : t -> t
    val bf_output : t -> t
    val bf_loop : t -> t -> t
  end

module Syntax =
  struct
    type t =
      | End
      | Inc of t
      | Dec of t
      | Left of t
      | Right of t
      | Input of t
      | Output of t
      | Loop of t * t
    (* Damnit, OCaml! *)
    let bf_end = End
    let bf_inc k = Inc k
    let bf_dec k = Dec k
    let bf_left k = Left k
    let bf_right k = Right k
    let bf_input k = Input k
    let bf_output k = Output k
    let bf_loop b k = Loop (b, k)
  end
    
let rec string_of_syntax s =
  let open Syntax in
  match s with
  | End -> ""
  | Inc k -> "+" ^ string_of_syntax k
  | Dec k -> "-" ^ string_of_syntax k
  | Left k -> "<" ^ string_of_syntax k
  | Right k -> ">" ^ string_of_syntax k
  | Input k -> "," ^ string_of_syntax k
  | Output k -> "." ^ string_of_syntax k
  | Loop (b, k) -> "[" ^ string_of_syntax b ^ "]" ^ string_of_syntax k

module RunnableSyntax (State : STATE) :
sig
  include SYNTAX
  val run : t -> State.t -> State.t
end
  =
  struct
    open State

    type t = State.t -> State.t

    let bf_end s = s
    and bf_inc k s = k (increment s)
    and bf_dec k s = k (decrement s)
    and bf_left k s = k (left s)
    and bf_right k s = k (right s)
    and bf_input k s = k (input s)
    and bf_output k s = k (output s)
    and bf_loop b k =
      let rec loop s =
        if not (is_zero s)
        then loop (b s)
        else k s
      in loop

    and run = (@@)
  end


let test () =
  let module BF = RunnableSyntax(ExampleState) in
  let open BF in
  let hello =
    bf_inc
    @@ bf_loop
         (bf_output @@ bf_inc bf_end)
         bf_end
  in run hello ExampleState.empty
     |> ignore
