FROM rocker/verse:latest
MAINTAINER "Peter Crosta" pmcrosta@gmail.com


# ------------------------------
# Install rstanarm and friends from Andrew Heiss (github.com/andrewheiss)
# ------------------------------
# Docker Hub (and Docker in general) chokes on memory issues when compiling
# with gcc, so copy custom CXX settings to /root/.R/Makevars and use ccache and
# clang++ instead

# Make ~/.R
RUN mkdir -p $HOME/.R

# $HOME doesn't exist in the COPY shell, so be explicit
COPY Makevars /root/.R/Makevars

# Install ggplot extensions like ggstance and ggrepel
# Install ed, since nloptr needs it to compile.
# Install all the dependencies needed by rstanarm and friends
# Install multidplyr for parallel tidyverse magic
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
 && apt-get -y --no-install-recommends install \
    ed \
    clang  \
    ccache \
    libiomp-dev \
    libpoppler-cpp-dev \
    build-essential \
    unixodbc \
    libgdal-dev \
    libgeos-dev \
    libfuse-dev \
    libudunits2-0 \
    libudunits2-dev \
    whois

# split up package installs
RUN install2.r --error \
        ggstance ggrepel \
        miniUI PKI RCurl RJSONIO packrat minqa nloptr matrixStats inline \
        colourpicker DT dygraphs gtools rsconnect shinyjs shinythemes threejs \
        xts bayesplot lme4 loo rstantools StanHeaders RcppEigen \
        rstan shinystan rstanarm \
        && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
		&& rm -rf /var/lib/apt/lists/*
    
RUN install2.r --error \    
        lambda.r semver sys abind acs ada Amelia aod arm C50 car caret choroplethr choroplethrMaps \        
        chron coda coin combinat data.tree dendextend descr DiagrammeR doMC doParallel downloader dummies \      
        e1071 earth effects elastic elasticsearchr evd fastmatch ff ffbase foreach forecast fracdiff gdata \        
        geosphere ggdendro ggmap ggthemes glmnet googleVis gridBase heplots humaniformat influenceR interplot \
        ipred irlba iterators jpeg kernlab klaR lava leaflet lmtest maxLik mda memisc miscTools modeltools \
        && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
		&& rm -rf /var/lib/apt/lists/*
        
RUN install2.r --error \  
        networkD3 NMF numDeriv party partykit pbapply pbkrtest pdftools pkgmaker plotly \
        plotmo plotrix png pROC prodlim proto quadprog QuantPsyc randomcoloR randomForest raster RcppArmadillo RecordLinkage \
        registry RForcecom RGA RGoogleAnalytics RgoogleMaps rJava RJDBC rjson R.methodsS3 rngtools R.oo RSelenium sna \        
        R.utils sampleSelection SAScii sendmailR shinyAce shinyBS shinydashboard sjmisc stargazer strucchange keras \
        survey systemfit timeDate truncdist tseries urltools V8 VGAM visNetwork WDI XLConnect XLConnectJars xlsx xlsxjars \
        class CVST ddalpha DEoptimR dimRed DRR imputeTS ModelMetrics quantmod ranger RcppRoll reporttools sfsmisc stinepack TTR odbc xgboost \
        && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
		&& rm -rf /var/lib/apt/lists/*

RUN R CMD javareconf \
    && R -e "library(devtools); \
        install_github('hadley/multidplyr');" \
    && rm -rf /var/lib/apt/lists/*













