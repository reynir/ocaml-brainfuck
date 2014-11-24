(* State *)

module type STATE =
  sig
    type t
    val empty : t
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
      let curr, left =
        match left with
        | [] -> 0, []
        | new_curr :: new_left -> new_curr, new_left
      and right = match curr, right with
        | 0, [] -> []
        | _ -> curr :: right
      in { left; curr; right }
    and right { left; curr; right } =
      let curr, right =
        match right with
        | [] -> 0, []
        | new_curr :: new_right -> new_curr, new_right
      and left = match curr, left with
        | 0, [] -> []
        | _ -> curr :: left
      in { left; curr; right }
    and input s =
      let curr = try int_of_char (input_char stdin)
                 with End_of_file -> 0
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
    val stop : t
    val inc : t -> t
    val dec : t -> t
    val left : t -> t
    val right : t -> t
    val input : t -> t
    val output : t -> t
    val loop : t -> t -> t
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
    let stop = End
    let inc k = Inc k
    let dec k = Dec k
    let left k = Left k
    let right k = Right k
    let input k = Input k
    let output k = Output k
    let loop b k = Loop (b, k)
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

let transform_syntax (type s) (module S : SYNTAX with type t = s)
    : Syntax.t -> S.t =
  let rec transform (s : Syntax.t) : S.t =
    match s with
    | Syntax.End -> S.stop
    | Syntax.Inc s' -> S.inc (transform s')
    | Syntax.Dec s' -> S.dec (transform s')
    | Syntax.Left s' -> S.left (transform s')
    | Syntax.Right s' -> S.right (transform s')
    | Syntax.Input s' -> S.input (transform s')
    | Syntax.Output s' -> S.output (transform s')
    | Syntax.Loop (b, s') -> S.loop (transform b) (transform s')
  in transform

module RunnableSyntax (State : STATE) :
sig
  include SYNTAX
  val run : t -> State.t -> State.t
  val of_syntax : Syntax.t -> t
end
  =
  struct
    (* Wrap the [SYNTAX] parts in a module so we can use [transform_syntax] *)
    module S = struct
      type t = State.t -> State.t
      let stop s = s
      and inc k s = k (State.increment s)
      and dec k s = k (State.decrement s)
      and left k s = k (State.left s)
      and right k s = k (State.right s)
      and input k s = k (State.input s)
      and output k s = k (State.output s)
      and loop b k =
        let rec loop s =
          if not (State.is_zero s)
          then loop (b s)
          else k s
        in loop
    end
    include S

    let run = (@@)

    let of_syntax = transform_syntax (module S)
  end

let test () =
  let module S = RunnableSyntax(ExampleState) in
  let hello =
    S.(inc
       @@ loop
            (output @@ inc stop)
            stop)
  in S.run hello ExampleState.empty
     |> ignore
