#!/bin/bash
find "${BUILT_PRODUCTS_DIR}" -name "*.app" -exec xattr -cr {} \; 2>/dev/null
