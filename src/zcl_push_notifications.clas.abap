CLASS zcl_push_notifications DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

    PUBLIC SECTION.

        CLASS-METHODS:

            severity_to_priority
                IMPORTING
                    iv_SEVERITY TYPE IF_ABAP_BEHV_MESSAGE=>t_severity
                RETURNING
                    VALUE(rv_result) TYPE /iwngw/notification_priority,

            msgty_to_priority
                IMPORTING
                    iv_msgty TYPE sy-msgty
                RETURNING
                    VALUE(rv_result) TYPE /iwngw/notification_priority.

        METHODS:

            constructor
                IMPORTING
                    IV_PROVIDER_ID type /IWNGW/IF_NOTIF_PROVIDER=>TY_S_PROVIDER-ID,

            add_notification
                IMPORTING
                  iv_type_key TYPE /iwngw/notification_type_key
                  iv_type_version TYPE /iwngw/notification_type_vers DEFAULT '1'
                  iv_priority TYPE /iwngw/notification_priority DEFAULT 'HIGH'
                  it_recipients TYPE /iwngw/if_notif_provider=>ty_t_notification_recipient
                  it_parameters type /iwngw/if_notif_provider=>ty_t_notification_parameter,

            send
                raising
                  /IWNGW/CX_NOTIFICATION_API .


    PROTECTED SECTION.
        DATA:
            lV_PROVIDER_ID type /IWNGW/IF_NOTIF_PROVIDER=>TY_S_PROVIDER-ID,
            lT_NOTIFICATION type /IWNGW/IF_NOTIF_PROVIDER=>TY_T_NOTIFICATION.

    PRIVATE SECTION.

ENDCLASS.



CLASS zcl_push_notifications IMPLEMENTATION.

    METHOD severity_to_priority.

        rv_result = cond #(
            WHEN iv_severity eq IF_ABAP_BEHV_MESSAGE=>severity-error THEN 'HIGH'
            WHEN iv_severity eq IF_ABAP_BEHV_MESSAGE=>severity-warning THEN 'MEDIUM'
            else 'NEUTRAL'
        ).

    ENDMETHOD.

    METHOD msgty_to_priority.

        rv_result = cond #(
            WHEN iv_msgty eq 'W' THEN 'MEDIUM'
            WHEN iv_msgty eq 'S' or iv_msgty eq 'I' THEN 'NEUTRAL'
            else 'HIGH'
        ).

    ENDMETHOD.

    METHOD constructor.

        me->lv_provider_id = iv_provider_id.

    ENDMETHOD.

    METHOD add_notification.

        data(lv_guid) =  cl_system_uuid=>create_uuid_c32_static( ).

        APPEND VALUE #(
                ID = lv_guid
                TYPE_KEY = iv_type_key
                TYPE_VERSION = iv_type_version
                PRIORITY = iv_priority
                ACTOR_ID = SY-UNAME
*                ACTOR_TYPE =
                ACTOR_DISPLAY_TEXT = sy-uname
*                ACTOR_IMAGE_URL
                RECIPIENTS = it_recipients
                PARAMETERS = VALUE #(
                    (
                        language = sy-langu
                        parameters = it_parameters
                    )
                )
*                NAVIGATION_TARGET_OBJECT
*                NAVIGATION_TARGET_ACTION
*                NAVIGATION_PARAMETERS
            ) to me->lT_NOTIFICATION.

    ENDMETHOD.

    METHOD send.

        CHECK lt_notification is NOT INITIAL.

        /IWNGW/CL_NOTIFICATION_API=>create_notifications(
            iv_provider_id = lv_provider_id " Deve ser registrado na transação /IWNGW/BEP_NPREG e ativado na view /IWNGW/VB_REG_P
            it_notification = lt_notification
        ).

    ENDMETHOD.

ENDCLASS.
