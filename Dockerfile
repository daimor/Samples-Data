FROM daimor/intersystems-iris:2019.1.0S.111.0-community

WORKDIR /opt/samples

COPY ./Installer.cls ./
COPY ./cls/ ./cls/
COPY ./gbl/ ./gbl/

RUN iris start $ISC_PACKAGE_INSTANCENAME quietly EmergencyId=sys,sys && \
    /bin/echo -e "sys\nsys\n" \
            " Do ##class(Security.Users).UnExpireUserPasswords(\"*\")\n" \
            " Do ##class(Security.Users).AddRoles(\"admin\", \"%ALL\")\n" \
            " do \$system.OBJ.Load(\"/opt/samples/Installer.cls\",\"ck\")\n" \
            " set sc = ##class(Samples.Installer).setup(, 3)\n" \
            " if 'sc do \$zu(4, \$JOB, 1)\n" \
            " halt" \
    | iris session $ISC_PACKAGE_INSTANCENAME -UUSER && \
    /bin/echo -e "sys\nsys\n" \
    | iris stop $ISC_PACKAGE_INSTANCENAME quietly

CMD [ "-l", "/usr/irissys/mgr/messages.log" ]

ENTRYPOINT [ "/bin/bash" ]