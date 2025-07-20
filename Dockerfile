# Use the rocker/shiny base image
FROM rocker/shiny:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libpoppler-cpp-dev \
    pandoc \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-fonts-recommended \
    texlive-extra-utils \
    texlive-latex-extra \
    libcurl4-openssl-dev \
    libpoppler-cpp-dev \
    libpoppler-private-dev \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install required R packages
RUN R -e "options(repos = list(CRAN = 'https://cloud.r-project.org')); install.packages(c( \
  'shiny', 'shinyFiles', 'statcheck', 'pdftools', 'tm', 'markdown', 'readr', 'htm2txt', \
  'DT', 'remotes', 'readtext'))"

# Downgrade bslib after remotes is available
RUN R -e "remotes::install_version('bslib', version = '0.4.2', \
  repos = 'http://cran.us.r-project.org', upgrade = 'never', dependencies = FALSE)"

# Copy the application code
COPY . /srv/shiny-server/

# Set permissions
RUN chown -R shiny:shiny /srv/shiny-server

# Expose port
EXPOSE 3838

# Run the Shiny app
CMD ["/usr/bin/shiny-server"]
