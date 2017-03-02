# elm-alternative-json
An alternative to core's JSON decoder! This package is mostly intended as a talking/starting point.

```
decodeModel : Json.Value -> Result String Model
decodeModel value =
  Ok { name = "", age = 0 } 
    |> decodeField "age" Json.int setAge value
    |> decodeField "name" Json.string setName value
```
