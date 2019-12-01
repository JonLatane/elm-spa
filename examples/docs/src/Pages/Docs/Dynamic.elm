module Pages.Docs.Dynamic exposing (Model, Msg, page)

import Element exposing (..)
import Generated.Docs.Params as Params
import Http
import Json.Decode as D exposing (Decoder)
import Spa.Page
import Ui
import Utils.Markdown as Markdown exposing (Markdown)
import Utils.Spa exposing (Page)
import Utils.WebData as WebData exposing (WebData(..))


page : Page Params.Dynamic Model Msg model msg appMsg
page =
    Spa.Page.element
        { title = \{ model } -> String.join " | " [ model.slug, "docs", "elm-spa" ]
        , init = always init
        , update = always update
        , subscriptions = always subscriptions
        , view = always view
        }



-- INIT


type alias Model =
    { slug : String
    , markdown : WebData (Markdown Markdown.Frontmatter)
    }


init : Params.Dynamic -> ( Model, Cmd Msg )
init { param1 } =
    ( { slug = param1
      , markdown = Loading
      }
    , Http.get
        { url = "/" ++ String.join "/" [ "content", "docs", param1 ++ ".md" ]
        , expect = WebData.expectMarkdown Loaded
        }
    )



-- UPDATE


type Msg
    = Loaded (WebData (Markdown Markdown.Frontmatter))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Loaded data ->
            ( { model | markdown = data }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Element Msg
view model =
    Ui.webDataMarkdownArticle
        { fallbackTitle = model.slug
        , markdown = model.markdown
        }