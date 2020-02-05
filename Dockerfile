FROM ubuntu:latest

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc



RUN apt-get install -y mdbtools
RUN apt-get install -y vim



RUN conda update -n base -c defaults conda


RUN useradd -ms /bin/bash ife
USER ife
WORKDIR /home/ife

RUN wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/jepegit/cellpy/master/environment.yml

RUN conda config --add channels jepegit
#RUN conda config --add channels conda-forge

RUN conda env create -f environment.yml
ENV PATH /home/ife/.local/bin/:$PATH
RUN echo "source activate cellpy" > ~/.bashrc
RUN /bin/bash -c "source activate cellpy && pip install --pre cellpy"
CMD [ "/bin/bash" ]
#RUN conda create -n cellpy python=3.7 pandas






