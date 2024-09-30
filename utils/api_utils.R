box::use(
  config[
    get
  ],
  httr2[
    request,
    req_url_query,
    req_headers,
    req_perform,
    resp_body_json
  ],
  glue[
    glue
  ],
  jsonlite[
    toJSON
  ],
  purrr[
    map,
    imap
  ],
)

#' Retrieve the API key from environment variables.
#'
#' @return The API key as a string.
#' @throws Error if the API key is not set in the environment.
get_api_key <- function(
) {
  api_key <- Sys.getenv("API_KEY")
  if (nchar(api_key) > 1) {
    api_key
  } else {
    stop("API_KEY not set as an environment variable.")
  }
}

#' Make the endpoint using the environment variable API_PATH
#' @param path The path to append to the API_PATH
#' @return Character. A full endpoint with the url
make_endpoint <- function(
  path
) {
  api_path <- Sys.getenv("API_PATH")
  if (nchar(api_path) > 1) {
    glue("{api_path}{path}")
  } else {
    stop("API_PATH not set as an environment variable.")
  }
}

#' Send an API GET request.
#'
#' @param endpoint The API endpoint URL.
#' @param ... Additional parameters to include in the request.
#' @return The parsed JSON response.
#' @export
process_get_api <- function(
  endpoint = NULL,
  ...
) {
  print(
    glue(
      "Processing: {endpoint}"
    )
  )
  response <- request(
    make_endpoint(
      endpoint
    )
  ) |>
    req_headers(
      accept = "*/*",
      `X-API-KEY` = get_api_key(),
    ) |>
    req_perform() |>
    resp_body_json()
}

#' Create a complete endpoint URL from base and suffix.
#'
#' @param base The base URL or endpoint.
#' @param suffixes The suffix or additional path segments to append.
#' @return A full API endpoint URL.
create_endpoints <- function(base, suffixes) glue("{base}/{suffixes}")

#' Generate a list of API endpoints from the config.
#'
#' @param cfg The configuration object (default loads from `config::get()`).
#' @return A flattened list of all endpoints.
#' @export
generate_endpoints <- function(
  cfg = get()
) {
  imap(
    cfg$endpoints,
    function(
      suffixes,
      key
    ) {
      base <- gsub("_", "/", key)
      map(
        suffixes,
        function(suffix) create_endpoints(base, suffix)
      )
    }
  ) |>
    unlist(recursive = TRUE) |>
    unname()
}
