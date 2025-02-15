library(tibble)
library(magrittr)
library(paletteer)
library(stringr)

ggthemes_c_seq_names <- names(ggthemes::ggthemes_data$tableau$`color-palettes`$`ordered-sequential`)
ggthemes_c_diq_names <- names(ggthemes::ggthemes_data$tableau$`color-palettes`$`ordered-diverging`)

ggthemes_df <- tibble(
  package = "ggthemes",
  palette = c(ggthemes_c_seq_names, ggthemes_c_diq_names),
  type = c(
    rep("sequential", length(ggthemes_c_seq_names)),
    rep("diverging", length(ggthemes_c_diq_names))
  )
)

pals_df <- tibble(
  package = "pals",
  palette = names(pals:::syspals)
) %>%
  dplyr::filter(
    !str_detect(palette, "^brewer"),
    !str_detect(palette, "glasbey|kelly|stepped|tol|watlington"),
    !str_detect(palette, "okabe|tableau20"),
    !str_detect(palette, "viridis|inferno|magma|plasma|cividis")
  ) %>%
  dplyr::mutate(type = c(
    rep("diverging", 2), rep("sequential", 19),
    rep("diverging", 3), rep("sequential", 11),
    rep("diverging", 5), rep("sequential", 1),
    rep("diverging", 8), rep("sequential", 28)
  ))

scico_df <- tibble(
  package = "scico",
  palette = names(scico:::palettes)
) %>%
  dplyr::mutate(type = c(
    "sequential", "sequential", "sequential", "diverging", "sequential",
    "diverging", "diverging", "sequential", "diverging", "diverging",
    "sequential", "sequential", "sequential", "sequential", "sequential",
    "sequential", "sequential", "diverging", "sequential", "sequential",
    "sequential", "diverging", "diverging", "diverging", "sequential",
    "sequential", "diverging", "diverging"
  ))

other_df <- tribble(
  ~package, ~palette, ~type,
  "grDevices", "rainbow", "sequential",
  "grDevices", "heat.colors", "sequential",
  "grDevices", "terrain.colors", "sequential",
  "grDevices", "topo.colors", "sequential",
  "grDevices", "cm.colors", "diverging",
  "oompaBase", "redscale", "sequential",
  "oompaBase", "greenscale", "sequential",
  "oompaBase", "bluescale", "sequential",
  "oompaBase", "blueyellow", "diverging",
  "oompaBase", "cyanyellow", "diverging",
  "oompaBase", "redgreen", "diverging",
  "oompaBase", "jetColors", "sequential",
  "oompaBase", "greyscale", "sequential",
  "palr", "bathy_deep_pal", "sequential",
  "palr", "chl_pal", "sequential",
  "palr", "ice_pal", "sequential",
  "palr", "sst_pal", "sequential",
  "viridis", "viridis", "sequential",
  "viridis", "inferno", "sequential",
  "viridis", "magma", "sequential",
  "viridis", "plasma", "sequential",
  "viridis", "cividis", "sequential"
) %>% as.data.frame()

hcl_df <- c("qualitative", "sequential", "diverging", "divergingx") %>%
  purrr::map_dfr(~ tibble(
    package = "grDevices",
    palette = hcl.pals(.x),
    type = .x
  )) %>%
  dplyr::mutate(type = dplyr::if_else(type == "divergingx", "diverging", type))

harrypotter_df <- tibble(
  package = "harrypotter",
  palette = unique(harrypotter::hp.map$option),
  type = "sequential"
)

gameofthrones_df <- tibble(
  package = "gameofthrones",
  palette = unique(gameofthrones::got.map$house),
  type = "sequential"
)

palettes_c_names <- dplyr::bind_rows(
  ggthemes_df,
  pals_df,
  scico_df,
  other_df,
  hcl_df,
  harrypotter_df,
  gameofthrones_df
) %>%
  dplyr::arrange(package) %>%
  as.data.frame()

usethis::use_data(palettes_c_names, overwrite = TRUE)
