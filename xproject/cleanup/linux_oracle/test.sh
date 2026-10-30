#!/bin/bash

file="#SFS#_c42f5bcbc95fe77ca35ef09c2c14617c2d47eb75b4344a4c7d14c0c9a34d3c71.xml"
file_lower="${file,,}"

echo $file
echo "Filename: $file_lower"

if [[ "$file_lower" =~ ^#?.*\.(xlsx|kz|xml)$ ]]; then
    echo "Matched"
else
    echo "Not matched"
fi