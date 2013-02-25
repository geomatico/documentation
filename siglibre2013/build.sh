echo "Needs python-docutils"
rst2odt --create-links --stylesheet=siglibre-template.odt geoserver-paper.rst geoserver-paper.odt

echo "Needs unoconv"
odt2pdf geoserver-paper.odt geoserver-paper.pdf

echo "Needs acroread"
acroread geoserver-paper.pdf &
