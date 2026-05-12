/* ── 버튼 권한 제어 공통 모듈 ── */
/* 각 JSP에서 setInsertMode/loadDetail 등 모드 전환 시 applyButtonPerms(mode) 를 호출합니다. */

//function applyButtonPerms(mode) {
//    let perm = pagePerm || { ins: 'Y', upd: 'Y', del: 'Y' };
//
//    /* 등록 전용 버튼 */
//    $('.btn-perm-ins').prop('disabled', perm.ins !== 'Y');
//
//    /* 삭제 버튼 */
//    $('.btn-perm-del').prop('disabled', perm.del !== 'Y');
//
//    /* 저장 버튼 (등록/수정 겸용): 현재 모드에 따라 권한 판단 */
//    if (mode === 'insert') {
//        $('.btn-perm-save').prop('disabled', perm.ins !== 'Y');
//    } else {
//        $('.btn-perm-save').prop('disabled', perm.upd !== 'Y');
//    }
//}
function applyButtonPerms() {
	
	/* 등록 전용 버튼 */
	$('.btn-perm-ins').prop('disabled', perm.ins !== 'Y');
	
	/* 삭제 버튼 */
	$('.btn-perm-del').prop('disabled', perm.del !== 'Y');
	
	/* 저장 버튼 (등록/수정 겸용): 현재 모드에 따라 권한 판단 */
	if (mode === 'insert') {
		$('.btn-perm-save').prop('disabled', perm.ins !== 'Y');
	} else {
		$('.btn-perm-save').prop('disabled', perm.upd !== 'Y');
	}
}
