FROM intel/oneapi-hpckit:2022.2-devel-ubuntu20.04

USER root

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends build-essential \
      gcc-9>=9.1.0 \
      gfortran-9>=9.1.0 \
      g++-9>=9.1.0 \
      ${transientBuildDeps} && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 \
      --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-9 && \
    update-alternatives --set gcc "/usr/bin/gcc-9" && \
    gcc --version && \
    gfortran --version && \
    apt-get clean && \
    apt-get purge -y --auto-remove ${transientBuildDeps} && \
    rm -rf /var/lib/apt/lists/* /var/log/* /tmp/*        

ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

USER ${NB_USER}
RUN cd ${HOME} && \
    git clone https://github.com/f66blog/binder_ifx.git && \
    cd binder_ifx  && \
    pip install --user ./jupyter-gfort-kernel  && \
    jupyter kernelspec install ./jupyter-gfort-kernel/gfort_spec --user 

WORKDIR ${HOME}/binder_ifx_


