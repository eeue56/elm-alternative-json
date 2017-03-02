port module Main exposing (..)

import Doc.Tests
import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)
import Json.Decode
import Json
import Test exposing (..)
import Expect
import Doc.JsonSpec


type alias Model =
    { name : String
    , age : Int
    , location : String
    }


setName : Model -> String -> Model
setName model name =
    { model | name = name }


setAge : Model -> Int -> Model
setAge model age =
    { model | age = age }


setLocation : Model -> String -> Model
setLocation model location =
    { model | location = location }


initialModel : Model
initialModel =
    { name = ""
    , age = 0
    , location = ""
    }


exampleValidJson : Value
exampleValidJson =
    Json.Encode.object
        [ ( "name", Json.Encode.string "noah" )
        , ( "age", Json.Encode.int 5 )
        , ( "location", Json.Encode.string "here" )
        ]


badJson : Value
badJson =
    Json.Encode.null


spec : Test
spec =
    Test.describe "Json"
        [ Test.test "Chaining decoders is nice"
            (\() ->
                Json.decodeField "name" Json.Decode.string setName exampleValidJson (Ok initialModel)
                    |> Json.decodeField "age" Json.Decode.int setAge exampleValidJson
                    |> Json.decodeField "location" Json.Decode.string setLocation exampleValidJson
                    |> Expect.equal (Ok { initialModel | name = "noah", age = 5, location = "here" })
            )
        , Test.test "Error messages are good"
            (\() ->
                Json.decodeField "name" Json.Decode.string setName badJson (Ok initialModel)
                    |> Json.decodeField "age" Json.Decode.int setAge badJson
                    |> Json.decodeField "location" Json.Decode.string setLocation badJson
                    |> Expect.equal (Err "Expecting an object with a field named `name` but instead got: null\nAnd Expecting an object with a field named `age` but instead got: null\nAnd Expecting an object with a field named `location` but instead got: null")
            )
        ]


all : Test
all =
    describe "Example"
        [ Doc.JsonSpec.spec
        , spec
        ]


main : TestProgram
main =
    run emit all


port emit : ( String, Value ) -> Cmd msg
