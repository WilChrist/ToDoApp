module Main exposing (..)


import Browser
import Html exposing (Html, Attribute, button, div, header,i,ul,li, span, input, text)
import Html.Attributes exposing(..)
import Html.Events exposing (onClick, onInput)



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL



type alias ToDo = {id:Int, sentence:String}


init : ToDo
init = {id=0, sentence=""}



-- UPDATE


type Msg
  = Create String
  | Change String
  | Delete Int
  | DeleteAll


update : Msg -> ToDo -> ToDo
update msg toDo =
  case msg of
    Change newSentence->
      {toDo | sentence=newSentence}
    Create newSentence->
      {toDo | sentence=newSentence}
    Delete idToDelete->
      {toDo | id=idToDelete}
    DeleteAll ->
      {toDo | sentence=""}




-- VIEW


view : ToDo -> Html Msg
view toDo =
  div [class "wrapper"]
    
    [ header [][text ("ELM Todo App")]
    , div [class "inputField"]
        [input [ placeholder "Create a new task", value toDo.sentence, onInput Change ] [ ]
        , button []
            [i [class "fas fa-plus"][]]
        , div [] [ text (String.fromInt (String.length toDo.sentence)) ]]
    , ul [class "todoList"] []
    , div [class "footer"] 
        [span[][text ("You have ")
                ,span[class "pendingTasks"][text("...")]
                , text (" pending tasks")]
        ,button[][text("Delete All")]]
    ]