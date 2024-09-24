*&---------------------------------------------------------------------*
*& Report zr_push_notif_set_rfc_to_none
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR_PUSH_NOTIF_SET_RFC_TO_NONE.

START-OF-SELECTION.

    SUBMIT /IWNGW/R_BEP_MAINT_HUB_DEST
    WITH p_t_hubd = 'NONE'
    AND RETURN.
