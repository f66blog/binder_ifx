FROM intel/oneapi-hpckit:2022.2-devel-ubuntu20.04

USER root

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends software-properties-common && \
    apt-get install -y --no-install-recommends build-essential && \
    apt-get clean && \
    apt-get purge -y --auto-remove ${transientBuildDeps} && \
    rm -rf /var/lib/apt/lists/* /var/log/* /tmp/*        

ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}

RUN cd ${HOME} && \
    git clone https://github.com/f66blog/binder_ifx.git && \
    cd binder_ifx  && \
    pip install --user ./jupyter-gfort-kernel  && \
    jupyter kernelspec install ./jupyter-gfort-kernel/gfort_spec --user 

WORKDIR ${HOME}/binder_ifx_


