; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -S -passes=attributor -aa-pipeline='basic-aa' -attributor-disable=false -attributor-max-iterations-verify -attributor-max-iterations=3 < %s | FileCheck %s
; PR 32917

@b = common local_unnamed_addr global i32 0, align 4
@a = common local_unnamed_addr global i32 0, align 4

define i32 @fn2() local_unnamed_addr {
; CHECK-LABEL: define {{[^@]+}}@fn2() local_unnamed_addr
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* @b, align 4
; CHECK-NEXT:    [[TMP2:%.*]] = sext i32 [[TMP1]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[TMP2]] to i32*
; CHECK-NEXT:    call fastcc void @fn1(i32* nofree [[TMP3]])
; CHECK-NEXT:    ret i32 undef
;
  %1 = load i32, i32* @b, align 4
  %2 = sext i32 %1 to i64
  %3 = inttoptr i64 %2 to i32*
  call fastcc void @fn1(i32* %3)
  ret i32 undef
}

define internal fastcc void @fn1(i32* nocapture readonly) unnamed_addr {
; CHECK-LABEL: define {{[^@]+}}@fn1
; CHECK-SAME: (i32* nocapture nofree nonnull readonly align 4 [[TMP0:%.*]]) unnamed_addr
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[TMP0]], i64 -1
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP2]], align 4
; CHECK-NEXT:    store i32 [[TMP3]], i32* @a, align 4
; CHECK-NEXT:    ret void
;
  %2 = getelementptr inbounds i32, i32* %0, i64 -1
  %3 = load i32, i32* %2, align 4
  store i32 %3, i32* @a, align 4
  ret void
}
