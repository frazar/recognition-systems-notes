FROM sumdoc/texlive-2018
COPY . /repo
RUN tlmgr update --self --all
CMD cd repo && pdflatex -shell-escape -synctex=1 -interaction=nonstopmode document.tex
