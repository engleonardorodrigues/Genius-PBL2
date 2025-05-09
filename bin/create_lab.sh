if [ $# -ne 1 ]; then
    echo "Usage: $0 <lab number, e.g., 02>"
    exit 1
fi

LAB_NUM=$1
LAB_NAME="lab${LAB_NUM}"
LAB_DIR="software/$LAB_NAME"
ASM_FILE="lab${LAB_NUM}.s"

mkdir -p "$LAB_DIR" || exit 1

cat > "$LAB_DIR/main.c" <<EOF
#include<stdio.h>

extern void func(int* a, int* b, int* result);

int main(){
    return 0;
}
EOF

cat > "$LAB_DIR/$ASM_FILE" <<EOF
.section .text

.global func

func:
    ret
EOF

echo "✅ Created $LAB_DIR with main.c and $ASM_FILE"