port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- MAIN


main =
    Browser.element { init = init, update = updateWithStorage, subscriptions = subscriptions, view = view }



-- PORT


port setStorage : Model -> Cmd msg


updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, cmds ) =
            update msg model
    in
    ( newModel
    , Cmd.batch [ setStorage newModel, cmds ]
    )



-- MODEL


type alias ToDo =
    { id : Int
    , sentence : String
    }


type alias Model =
    { todos : List ToDo
    , sentenceInput : String
    , uid : Int
    }


emptyToDo : ToDo
emptyToDo =
    { id = 0, sentence = "" }


emptyModel : Model
emptyModel =
    { todos = []
    , sentenceInput = ""
    , uid = 0
    }


init : Maybe Model -> ( Model, Cmd Msg )
init maybeModel =
    ( Maybe.withDefault emptyModel maybeModel
    , Cmd.none
    )



-- UPDATE


type Msg
    = Create
    | Change String
    | Delete Int
    | DeleteAll


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newSentence ->
            ( --let
              --_=Debug.log "CH=" model
              --in
              { model | sentenceInput = newSentence }
            , Cmd.none
            )

        Create ->
            ( --let
              --_=Debug.log "CR=" model
              --in
              { model
                | todos = addToCollection model.uid model.sentenceInput model.todos
                , sentenceInput = ""
                , uid = model.uid + 1
              }
            , Cmd.none
            )

        Delete idToDelete ->
            ( --let
              --_=Debug.log "D=" model
              --in
              { model | todos = deleteFromCollection idToDelete model.todos }
            , Cmd.none
            )

        DeleteAll ->
            ( --let
              --_=Debug.log "DQ=" model
              --in
              { model | todos = deleteAllFromCollection model.todos }
            , Cmd.none
            )


addToCollection : Int -> String -> List ToDo -> List ToDo
addToCollection uid sentenceInput todos =
    if String.isEmpty sentenceInput then
        todos

    else
        todos ++ [ { id = uid, sentence = sentenceInput } ]


deleteFromCollection : Int -> List ToDo -> List ToDo
deleteFromCollection idToDelete todos =
    List.filter (\t -> t.id /= idToDelete) todos


deleteAllFromCollection : List ToDo -> List ToDo
deleteAllFromCollection todos =
    []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "wrapper" ]
        [ header [] [ text "ELM Todo App" ]
        , div [ class "inputField" ]
            [ input [ autofocus True, placeholder "Create a new task", value model.sentenceInput, onInput Change ] []
            , button
                [ onClick Create
                , if String.length model.sentenceInput > 0 then
                    class "active"

                  else
                    class ""
                ]
                [ i [ class "fas fa-plus" ] [] ]
            ]
        , ul [ class "todoList" ] (List.map viewTodo model.todos)
        , div [ class "footer" ]
            [ span []
                [ text "You have "
                , span [ class "pendingTasks" ] [ text (String.fromInt (List.length model.todos)) ]
                , text " pending tasks"
                ]
            , button [ onClick DeleteAll ] [ text "Delete All" ]
            ]
        ]


viewTodo : ToDo -> Html Msg
viewTodo todo =
    li
        []
        [ text todo.sentence
        , span [ class "icon", onClick (Delete todo.id) ] [ i [ class "fas fa-trash" ] [] ]
        ]
