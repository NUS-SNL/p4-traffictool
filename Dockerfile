FROM p4lang/p4c:latest

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY configure.sh /configure.sh 
RUN /configure.sh
COPY . /p4c

