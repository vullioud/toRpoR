#'Plot raw data and predicted values of a fitted model
#'
#'[tor_plot()] provides a plot of the metabolic rate (M) values over the respective
#'ambient temperature (Ta).
#'
#'The function plots the predicted value as well as the raw data.
#'Measures are presented in different colors depending on the metabolic state.
#'Predicted values as well as 95% credible interval (segmented lines) are also presented.
#'This function enables the user to replicate the analysis done in Fasel et al. (in prep).
#'For more flexibility the users can use [tor_fit()] and [tor_predict()] directly.
#'
#'@name tor_plot
#'@param tor_obj a fitted model from [tor_fit()]
#'@param plot_type A character string specifying the type of plot desired. Either "base" or "ggplot". Note that ggplots are still in development stage.
#'@param legend A logical specifying if a legend should be added to the plot. Only work for base plot at the moment.
#'@param col_torp color for torpor model prediction and points
#'@param col_euth color for Euthermia model prediction and points
#'@param col_Mtnz color of Mtnz
#'@param ylab y label
#'@param xlab x label
#'@param xlim limit of the x-axis
#'@param ylim limit of the y-axis
#'@param pdf logical if a .pdf copy of the plot should be saved
#'@export
#'@return a graphics plot or a ggplot object
#'@importFrom grDevices dev.off

tor_plot <- function(tor_obj = NULL,
                     plot_type = "base",
                     col_torp = "cornflowerblue",
                     col_euth = "coral3",
                     col_Mtnz = "black",
                     ylab = "M",
                     xlab = "Ta",
                     xlim = NULL,
                     ylim = NULL,
                     legend = TRUE,
                     pdf = FALSE) {


  if(!("tor_obj" %in% class(tor_obj))) stop("tor_obj need to be of class tor_obj")

  ## please check
  assignment <- measured_Ta <- measured_M <- assignment <- NULL
  ## retrieve values from the model
  Tlc <- tor_obj$out_Mtnz_Tlc$Tlc_estimated
  Mtnz <- tor_obj$out_Mtnz_Tlc$Mtnz_estimated


  Y <- M <- tor_obj$data$Y
  Ta <- tor_obj$data$Ta

  # plotting limits and get values
  if (length(xlim) != 2 & !is.null(xlim)) stop("xlim must be a vector of length 2")

  Tlimup <- if(is.null(xlim)) max(Ta, na.rm=TRUE) else xlim[2]
  Tlimlo <- if(is.null(xlim)) min(Ta, na.rm=TRUE) else xlim[1]

  ## get the assignment and data
  da <- tor_assign(tor_obj)
  pred <- tor_predict(tor_obj, seq(Tlimlo,Tlimup,length=1000))

  ## get the values
  Ymeant <- pred[pred$assignment == "Torpor", "pred"]
  Y975t <- pred[pred$assignment == "Torpor", "upr_95"]
  Y025t <- pred[pred$assignment == "Torpor", "lwr_95"]

  Ymeann <- pred[pred$assignment == "Euthermia", "pred"]
  Y975n <- pred[pred$assignment == "Euthermia", "upr_95"]
  Y025n <- pred[pred$assignment == "Euthermia", "lwr_95"]

  YmeanM <- pred[pred$assignment == "Mtnz", "pred"]

  if(length(ylim) != 2 & !is.null(ylim)) stop("ylim must be a vector of length 2")

  MRup <- ifelse(is.null(ylim), max(Y975n,Y975t,Y,na.rm=TRUE), ylim[2])
  MRlo <- ifelse(is.null(ylim), min(Y025n,Y025t,Y,na.rm=TRUE), ylim[1])
  ## ggplot
  if(plot_type == "ggplot"){

    G <- lwr_95 <- upr_95 <- NULL ## check

    plot <- ggplot2::ggplot() +
      ggplot2::geom_point(data = da[da$assignment == "Torpor", ], ggplot2::aes(x = measured_Ta, y = measured_M, col = "Torpor"), col = col_torp) + ## torpor
      ggplot2::xlim(c(Tlimlo, Tlimup)) +
      ggplot2::ylim(c(MRlo, MRup)) +
      ggplot2::geom_line(data = pred[pred$assignment == "Torpor", ], ggplot2::aes(x = Ta, y = pred), col = col_torp,
                         linetype = 2) +
      ggplot2::geom_ribbon(data = pred[pred$assignment == "Torpor", ],
                           ggplot2::aes(x = Ta, ymin = lwr_95, ymax = upr_95), fill = col_torp,
                           alpha = 0.2,
                           col = NA) +
      ggplot2::geom_point(data = da[da$assignment == "Euthermia", ], ggplot2::aes(x = measured_Ta, y = measured_M, col = "Euthermia"), col = col_euth) + ## Euthermia
      ggplot2::geom_line(data = pred[pred$assignment == "Euthermia", ], ggplot2::aes(x = Ta, y = pred), col = col_euth,
                         linetype = 2) +
      ggplot2::geom_ribbon(data = pred[pred$assignment == "Euthermia", ],
                           ggplot2::aes(x = Ta, ymin = lwr_95, ymax = upr_95), fill = col_euth,
                           alpha = 0.2,
                           col = NA) +
      ggplot2::geom_point(data = da[da$assignment == "Mtnz", ], ggplot2::aes(x = measured_Ta, y = measured_M, col = "Mtnz"), col = col_Mtnz) + ## Euthermia
      ggplot2::geom_line(data = pred[pred$assignment == "Mtnz", ], ggplot2::aes(x = Ta, y = pred), col = col_Mtnz,
                         linetype = 2) +
      ggplot2::geom_point(data = da[da$assignment == "Undefined", ], ggplot2::aes(x = measured_Ta, y = measured_M), shape = 4) +
      ggplot2::theme_light() +
      ggplot2::xlab(xlab) +
      ggplot2::ylab(ylab)

    if (pdf == TRUE){
      ggplot2::ggsave(plot, filename = "plot.pdf", width = 7, units = "cm")
    }

    return(plot)

  ## base-R plot
  } else {

   ## plot
    if(pdf == TRUE){
      pdf("plot.pdf")
    }

    graphics::plot(da$measured_M~da$measured_Ta, type="n",frame=FALSE, xlim=c(Tlimlo, Tlimup),ylim=c(MRlo, MRup),ylab= ylab, xlab = xlab)
    graphics::points(da$measured_M[da$assignment == "Torpor"] ~ da$measured_Ta[da$assignment == "Torpor"],col = col_torp, pch = 19)
    graphics::points(da$measured_M[da$assignment == "Euthermia"] ~ da$measured_Ta[da$assignment == "Euthermia"],col = col_euth , pch = 19)
    graphics::points(da$measured_M[da$assignment == "Mtnz"] ~ da$measured_Ta[da$assignment == "Mtnz"],col = col_Mtnz , pch = 19)
    graphics::points(da$measured_M[da$assignment == "Undefined"] ~ da$measured_Ta[da$assignment == "Undefined"], pch = 3)

    if(length(da$assignment == "Torpor")> 0){
      X <-  pred[pred$assignment == "Torpor", "Ta"]
      graphics::par(new=TRUE)

      graphics::plot(Ymeant~X,xlim=c(Tlimlo, Tlimup),ylim=c(MRlo, MRup),type="l",xaxt="n",frame=FALSE,yaxt="n",ylab="",xlab="",col=col_torp)
      graphics::par(new=TRUE)

      graphics::plot(Y975t~X,xlim=c(Tlimlo, Tlimup),ylim=c(MRlo, MRup),type="l",lty=2,xaxt="n",frame=FALSE,yaxt="n",ylab="",xlab="",col=col_torp)
      graphics::par(new=TRUE)

      graphics::plot(Y025t~X,xlim=c(Tlimlo, Tlimup),ylim=c(MRlo, MRup),type="l",lty=2,xaxt="n",frame=FALSE,yaxt="n",ylab="",xlab="",col=col_torp)
    }


    if(length(da$assignment == "Euthermia")>0){
      X <-  pred[pred$assignment == "Euthermia", "Ta"]
      graphics::par(new=TRUE)

      graphics::plot(Ymeann~X,xlim=c(Tlimlo, Tlimup),ylim=c(MRlo, MRup),type="l",xaxt="n",frame=FALSE,yaxt="n",ylab="",xlab="",col=col_euth)
      graphics::par(new=TRUE)

      graphics::plot(Y975n~X,xlim=c(Tlimlo, Tlimup),ylim=c(MRlo, MRup),type="l",lty=2,xaxt="n",frame=FALSE,yaxt="n",ylab="",xlab="",col=col_euth)
      graphics::par(new=TRUE)

      graphics::plot(Y025n~X,xlim=c(Tlimlo, Tlimup),ylim=c(MRlo, MRup),type="l",lty=2,xaxt="n",frame=FALSE,yaxt="n",ylab="",xlab="",col=col_euth)

      }

    if(length(da$assignment == "Mtnz")>0){
      X <-  pred[pred$assignment == "Mtnz", "Ta"]
      graphics::par(new=TRUE)
      graphics::plot(YmeanM~X,xlim=c(Tlimlo, Tlimup),ylim=c(MRlo, MRup),type="l",xaxt="n",frame=FALSE,yaxt="n",ylab="",xlab="",col=col_Mtnz)

    }
    if (legend) {
    graphics::legend("topright", c("Euthermia","Torpor", "Mtnz", "Undefined"),
                     pch=c(19, 19,19, 3),
                     col=c(col_euth,col_torp, col_Mtnz, "black"),
                     bty="n")
    }

    if(pdf == TRUE){
      dev.off()
    }

  }
}

