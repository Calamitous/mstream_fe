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
subscriptions model = Sub.none

init : (Model, Cmd Msg)
init = (starter_model, Cmd.none)

-- MODEL
type alias Model =
  { username : String
    , password : String
    , server_url : String
    , response : String
    }

type alias File =
  { path : String
  , contents : List String
  }


-- UPDATE
type Msg =
  Login
  | LoggedIn(Result Http.Error String)
  | Username String
  | Password String
  | ServerUrl String

update msg model =
  case msg of
    Login                     -> ({model | response = "Connecting..."}, (doLogin model))
    LoggedIn (Ok response)    -> ({model | response = response}, Cmd.none)
    LoggedIn (Err err)        -> ({model | response = (errorMaker err)}, Cmd.none)
    Username (username)       -> ({model | username = username}, Cmd.none)
    Password (password)       -> ({model | password = password}, Cmd.none)
    ServerUrl (server_url)    -> ({model | server_url = server_url}, Cmd.none)

errorMaker : Http.Error -> String
errorMaker err =
  case err of
    Http.NetworkError              -> "Could not connect"
    Http.BadUrl response           -> "Bad URL: " ++ response
    Http.Timeout                   -> "Connection timed out"
    Http.BadStatus response        -> "Bad Status"
    Http.BadPayload error response -> "Bad Payload"


loginUrl : Model -> String
loginUrl model =
  model.server_url ++ "/login"

doLogin : Model -> Cmd Msg
doLogin model =
  Http.send LoggedIn (Http.post (loginUrl model) Http.emptyBody (Json.Decode.string))
  -- Http.send LoggedIn (Http.get "https://jsonplaceholder.typicode.com/posts" (Json.Decode.string))


-- { username: model.username, password: model.password }

showFile content =
  div [ class "row" ] [
    div [ class "8 col" ] [ text content ]
    , div [ class "2 col" ] [
    ]
  ]

-- VIEW
view model =
  div [ class "c" ] [
    h1 [] [ text "Access connect" ]
    , div [ class "c" ] [ text model.response ]
    , div [ class "c" ] [
      div [ class "row" ] [ div [ class "8 col" ] [
          input [ type_ "text", name "server_url", placeholder "Server Url", onInput ServerUrl ] []
        ] ]
      , div [ class "row" ] [ div [ class "8 col" ] [
          input [ type_ "text", name "username", placeholder "User Name", onInput Username ] []
        ] ]
      , div [ class "row" ] [ div [ class "8 col" ] [
          input [ type_ "password", name "password", placeholder "Password", onInput Password ] [ text "http://music.pencricket.com:8888" ]
        ] ]
      , div [ class "row" ] [ div [ class "8 col" ] [
          button [ onClick Login ] [ text "HIT ME"]
        ] ]
    ]
  ]

