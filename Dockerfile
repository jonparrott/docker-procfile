# Copyright 2015 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM python:2.7-slim
MAINTAINER Jon Wayne Parrott <jon.wayne.parrott@gmail.com>

# psutil requires gcc, so we'll install build-essential.
RUN apt-get update -y -q && \
    apt-get install --no-install-recommends -y -q \
        build-essential && \
    apt-get clean && \
    rm /var/lib/apt/lists/*_*

# Copy over the application source and install all requirements into the
# virtualenv.
WORKDIR /app
RUN virtualenv /env
ADD requirements.txt /app/requirements.txt
RUN /env/bin/pip install -r /app/requirements.txt
ADD . /app

EXPOSE 8080

# Activate the virtualenv (so that python points to the right thing in honcho)
# and then start all honcho processes.
CMD . /env/bin/activate; /env/bin/honcho start
