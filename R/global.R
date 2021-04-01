#' @importFrom magrittr %>%
#' @importFrom ggplot2 aes
plot_annual <- function(df){
    dplyr::mutate(df, Year = as.numeric(substr(Month, 1, 4))) %>%
    dplyr::group_by(Year) %>%
    dplyr::summarise(Annual_Sum = sum(Replies)) %>%
    ggplot2::ggplot() +
    ggplot2::geom_bar(aes(Year, Annual_Sum, fill = Year), stat = 'identity') +
    ggplot2::theme(legend.position = '') +
    theme_my
}

#' @importFrom magrittr %>%
plot_monthly <- function(df){
  ts_rdevel <-
    dplyr::group_by(df, Month) %>%
    dplyr::summarise(Monthly_Sum = sum(Replies))
  ts_year <- min(as.numeric(substr(ts_rdevel$Month, 1, 4)))
  ts_month <- min(as.numeric(substr(ts_rdevel$Month, 6, 7)))
  dygraphs::dygraph(ts(ts_rdevel$Monthly_Sum, start=c(ts_year, ts_month), frequency=12), xlab = 'Time', ylab = 'Monthly Sum')
}

#' @importFrom ggplot2 aes
plot_dist <- function(df){
  ggplot2::ggplot(df, aes(x = Replies)) +
    ggplot2::geom_histogram() +
    ggplot2::labs(x = 'Replies of a post', y = 'Count of posts') +
    theme_my
}

#' @importFrom magrittr %>%
#' @importFrom ggplot2 aes
plot_author <- function(df){
  df_sum <-
    dplyr::group_by(df, Author) %>%
    dplyr::summarise(Replies = sum(Replies))
  df_sum <-  df_sum[order(-df_sum$Replies), ]
  df_sum <- df_sum[1:20, ]
  df_sum$Author <- factor(df_sum$Author, levels = rev(df_sum$Author))
  ggplot2::ggplot(df_sum) +
    ggplot2::geom_bar(aes(Author, Replies, fill = Author), stat = 'identity') +
    ggplot2::theme(legend.position = '') +
    ggplot2::coord_flip() +
    theme_my
}

#' @importFrom ggplot2 aes
plot_hour <- function(df){
  ggplot2::ggplot(df, aes(round(hour))) +
    ggplot2::geom_bar(fill = 'grey') +
    ggplot2::scale_x_continuous(breaks = seq(0, 24, 3), minor_breaks = 0:24, expand = c(0.002, 0)) +
    ggplot2::labs(x = 'Active Hour of the Day', y ='Posts') +
    ggplot2::coord_polar(start = -1/24 * pi) +
    theme_my
}

theme_my <-  ggplot2::theme(
  axis.text.x = ggplot2::element_text(size = 12),
  axis.text.y = ggplot2::element_text(size = 12),
  axis.title.x = ggplot2::element_text(size = 14),
  axis.title.y = ggplot2::element_text(size = 14))
