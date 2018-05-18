import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date exposing (..)
import Task exposing (..)
import List

import Http
import Json.Encode
import Json.Decode exposing (list, string)

starter_model = Model "" "" "" ""
files = File "/" []

-- main = Html.beginnerProgram { model = starter_model, view = view, update = update }
main =
  Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

init : (Model, Cmd Msg)
init =
    ( starter_model
      , Cmd.none
        )

-- MODEL
type alias Model =
  { user : String
    , password : String
    , server_url : String
    , response : String
    }

type alias File =
  { path : String
  , contents : List String
  }


-- UPDATE
type Msg = Login | LoggedIn(Result Http.Error String)
update msg model =
  case msg of
    Login              -> (model, (doLogin model))
    LoggedIn (Ok resp) -> (Model model.user model.password model.server_url resp, Cmd.none)
    LoggedIn (Err _)   -> (model, Cmd.none)

loginUrl : Model -> String
loginUrl model =
  model.server_url ++ "/login"

doLogin : Model -> Cmd Msg
doLogin model =
  Http.send LoggedIn (Http.post (loginUrl model) Http.emptyBody (Json.Decode.string))

-- { username: model.user, password: model.password }

showFile content =
  div [ class "row" ] [
    div [ class "8 col" ] [ text content ]
    , div [ class "2 col" ] [
    ]
  ]

-- VIEW
view model =
  div [ class "c" ] [
    button [ onClick Login ] [ text "Do it"]
    , h1 [] [ text "Well howdy there!" ]
    , div [ class "c" ] [ text model.response ]
    -- (List.map showFile files.contents)
  ]

