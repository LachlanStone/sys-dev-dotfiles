#!/bin/bash
# Script to seal Kubernetes Secret YAML files using kubeseal
# DO NOT COMMIT sealed secrets private keys to git

set -euo pipefail

CONTROLLER_NAMESPACE="sealed-secrets"
CONTROLLER_NAME="sealed-secrets"

# Header for single-file modes
HEADER_SINGLE=$'\e[1;36mSealed Secrets controller:\e[0m
\e[1;33mController name:\e[0m '"${CONTROLLER_NAME}"$'
\e[1;33mController namespace:\e[0m '"${CONTROLLER_NAMESPACE}"

# Header for multi-file modes (adds multi-select help)
HEADER_MULTI=$'\e[1;36mSealed Secrets controller:\e[0m
\e[1;33mController name:\e[0m '"${CONTROLLER_NAME}"$'
\e[1;33mController namespace:\e[0m '"${CONTROLLER_NAMESPACE}"$'

\e[1;36mMulti‑select controls:\e[0m
  \e[1;32mTAB\e[0m        mark/unmark a file
  \e[1;32mSHIFT+TAB\e[0m unmark
  \e[1;32mENTER\e[0m     confirm selection'

# Preview command: bat > batcat > sed
if command -v bat &> /dev/null; then
  PREVIEW_OPTS=(--preview 'bat --style=numbers --color=always {}' --preview-window=right:60%:wrap)
elif command -v batcat &> /dev/null; then
  PREVIEW_OPTS=(--preview 'batcat --style=numbers --color=always {}' --preview-window=right:60%:wrap)
else
  PREVIEW_OPTS=(--preview 'sed -n "1,200p" {}' --preview-window=right:60%:wrap)
fi

echo -e "Sealed Secrets controller:"
echo -e "  - Controller name:      ${CONTROLLER_NAME}"
echo -e "  - Controller namespace: ${CONTROLLER_NAMESPACE}"
echo

# Enable nullglob so unmatched globs expand to nothing
shopt -s nullglob

FILES=( *.yaml *.yml )

if [ ${#FILES[@]} -eq 0 ]; then
  echo "No .yaml or .yml files found in current directory."
  exit 1
fi

echo "Choose selection mode:"
echo "  1) Single file (colored header at top)  [recommended]"
echo "  2) Single file (YAML content preview)"
echo "  3) Multi-file sealing"
echo "  4) Multi-file sealing (YAML content preview)"
echo

read -p "Enter your choice: " MODE

##############################################
# OPTION 1 — Single file, header at top
##############################################
if [ "$MODE" -eq 1 ]; then
  echo "Using: fzf with colored header at top"
  FILE=$(printf "%s\n" "${FILES[@]}" | fzf \
    --prompt="YAML file: " \
    --header-first \
    --header="$HEADER_SINGLE"
  )

##############################################
# OPTION 2 — Single file with YAML preview
##############################################
elif [ "$MODE" -eq 2 ]; then
  echo "Using: YAML content preview"
  FILE=$(printf "%s\n" "${FILES[@]}" | fzf \
    --prompt="YAML file: " \
    --header-first \
    --header="$HEADER_SINGLE" \
    "${PREVIEW_OPTS[@]}"
  )

##############################################
# OPTION 3 — Multi-file sealing
##############################################
elif [ "$MODE" -eq 3 ]; then
  echo "Using: multi-file sealing"
  SELECTED=$(printf "%s\n" "${FILES[@]}" | fzf -m \
    --prompt="Select files: " \
    --header-first \
    --header="$HEADER_MULTI"
  )

  if [ -z "$SELECTED" ]; then
    echo "No files selected."
    exit 1
  fi

  for FILE in $SELECTED; do
    BASENAME="${FILE##*/}"
    DEFAULT_NAME="${BASENAME%.*}"
    OUTPUT="${DEFAULT_NAME}-sealed.yaml"

    echo "Sealing $FILE → $OUTPUT"

    kubeseal \
      --controller-name "$CONTROLLER_NAME" \
      --controller-namespace "$CONTROLLER_NAMESPACE" \
      --format yaml < "$FILE" > "$OUTPUT"
  done

  echo "All selected files sealed."
  exit 0

##############################################
# OPTION 4 — Multi-file sealing WITH YAML preview
##############################################
elif [ "$MODE" -eq 4 ]; then
  echo "Using: multi-file sealing with YAML preview"
  SELECTED=$(printf "%s\n" "${FILES[@]}" | fzf -m \
    --prompt="Select files: " \
    --header-first \
    --header="$HEADER_MULTI" \
    "${PREVIEW_OPTS[@]}"
  )

  if [ -z "$SELECTED" ]; then
    echo "No files selected."
    exit 1
  fi

  for FILE in $SELECTED; do
    BASENAME="${FILE##*/}"
    DEFAULT_NAME="${BASENAME%.*}"
    OUTPUT="${DEFAULT_NAME}-sealed.yaml"

    echo "Sealing $FILE → $OUTPUT"

    kubeseal \
      --controller-name "$CONTROLLER_NAME" \
      --controller-namespace "$CONTROLLER_NAMESPACE" \
      --format yaml < "$FILE" > "$OUTPUT"
  done

  echo "All selected files sealed."
  exit 0

else
  echo "Invalid selection."
  exit 1
fi

##############################################
# COMMON SEALING LOGIC (single file)
##############################################

if [ -z "${FILE:-}" ]; then
  echo "No file selected."
  exit 1
fi

BASENAME="${FILE##*/}"
DEFAULT_NAME="${BASENAME%.*}"

read -p "Enter sealed secret name [default: $DEFAULT_NAME]: " NAME
NAME=${NAME:-$DEFAULT_NAME}

OUTPUT="${NAME}-sealed.yaml"

echo
echo "Sealing:"
echo "  - Input file:  ${FILE}"
echo "  - Output file: ${OUTPUT}"
echo "  - Secret name: ${NAME}"
echo

kubeseal \
  --controller-name "$CONTROLLER_NAME" \
  --controller-namespace "$CONTROLLER_NAMESPACE" \
  --format yaml < "$FILE" > "$OUTPUT"

echo "Sealed secret written to $OUTPUT"

