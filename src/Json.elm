module Json exposing (..)

{-|
This module is intended to explore an alternative API to Json.
@docs decodeField
-}

import Json.Encode
import Json.Decode as Json


{-|
    Decode a field using a given setter to get it out of an object. This function is designed to be chained!

    >>> import Json.Decode
    >>> import Json.Encode
    >>> decodeField
    ... "name"
    ... Json.Decode.string
    ... (\model name -> { model | name = name })
    ... (Json.Encode.object [ ("name", Json.Encode.string "noah") ])
    ... (Ok { name = "" })
    Ok { name = "noah" }

    >>> decodeField
    ... "name"
    ... Json.Decode.string
    ... (\model name -> { model | name = name })
    ... (Json.Encode.object [ ("age", Json.Encode.int 18) ])
    ... (Ok { name = "" })
    Err "Expecting an object with a field named `name` but instead got: {\"age\":18}"

    >>> decodeField
    ... "name"
    ... Json.Decode.string
    ... (\model name -> { model | name = name })
    ... (Json.Encode.object [ ("age", Json.Encode.int 18) ])
    ... (Err "Something failed!")
    Err "Something failed!\nAnd Expecting an object with a field named `name` but instead got: {\"age\":18}"
-}
decodeField :
    String
    -> Json.Decoder a
    -> (model -> a -> model)
    -> Json.Value
    -> Result String model
    -> Result String model
decodeField fieldName decoder setter value model =
    case model of
        Err s ->
            case Json.decodeValue (Json.field fieldName decoder) value of
                Err newMessage ->
                    Err (s ++ "\nAnd " ++ newMessage)

                Ok _ ->
                    model

        Ok v ->
            Json.decodeValue (Json.field fieldName decoder) value
                |> Result.map (setter v)
