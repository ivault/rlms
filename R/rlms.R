#' rlms
#'
#' @name rlms
#' @docType package
#' @author Boris Demeshev 
#' @import foreign dplyr
NULL

#' Read rlms data
#'
#' Read rlms data and all meta information
#'
#' Read rlms data and all the meta information. Destroy useless attributes.
#'
#' @param file the filename
#' @return dataframe
#' @examples
#' read.rlms("r21i_os24a.sav")
read.rlms <- function(file, suppress=FALSE) {
  df <- read.spss(file, to.data.frame = TRUE, reencode = "UTF-8")
  attr(df, "codepage") <- NULL
  
  # get variable labels
  varlabel=attr(df,"variable.labels")
  names(varlabel) <- NULL
  var_meta <- data_frame(var=names(df), varlabel=varlabel)
  attr(df,"variable.labels") <- NULL
  
  # get value labels
  value_meta <- NULL
  
  for (i in 1:ncol(df)) {  
    value <- attr(df[,i],"value.labels")
    
    if (!is.null(value)) {
      vallabel <- names(value)
      attr(value,"names") <- NULL
      temp <- data_frame(value=value, vallabel=vallabel, var=names(df)[i])
      value_meta <- rbind(value_meta,temp)
      attr(df[,i],"value.labels") <- NULL
    }
  }
  
  
  attr(df,"var_meta") <- var_meta
  attr(df,"value_meta") <- value_meta
  
  if (!suppress) {
    message("Variable labels: attr(df, 'var_meta'). Value labels: attr(df, 'value_meta').")
    message("You may extract meta information now. Later some functions may destroy meta information. ")
    message("This message may be turned off with option: suppress=TRUE. ")
  }
  
  return(df)
}