#!/usr/bin/env bash

kns() {
  # Get all namespaces into an array safely
  mapfile -t namespaces < <(kubectl get ns --no-headers -o custom-columns=":metadata.name")

  echo "Choose selection mode:"
  echo "1) Number menu (pure bash)"
  echo "2) Arrow keys (fzf)"
  read -rp "Enter choice [1-2, default=2]: " mode

  # Default to 1 if nothing entered
  mode=${mode:-2}

  case "$mode" in
    1)
      # Pure bash select menu
      PS3="Pick a namespace: "
      select ns in "${namespaces[@]}"; do
        if [[ -n "$ns" ]]; then
          kubectl config set-context --current --namespace="$ns"
          echo "✅ Switched to namespace: $ns"
          break
        else
          echo "Invalid choice"
        fi
      done
      ;;
    2)
      # fzf menu (requires fzf installed)
      ns=$(printf "%s\n" "${namespaces[@]}" | fzf)
      if [[ -n "$ns" ]]; then
        kubectl config set-context --current --namespace="$ns"
        echo "✅ Switched to namespace: $ns"
      fi
      ;;
    *)
      echo "Invalid mode selected"
      ;;
  esac
}
kns
