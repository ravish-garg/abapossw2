CLASS yrgcl_abap2ui5_week2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    INTERFACES z2ui5_if_app.
    DATA: date TYPE datn,
          user TYPE string VALUE 'Ravish Garg'.
    DATA:
      BEGIN OF screen,
        check_is_active TYPE abap_bool,
        colour          TYPE string,
        combo_key       TYPE string,
        combo_key2      TYPE string,
        segment_key     TYPE string,
        date            TYPE string,
        date_time       TYPE string,
        time_start      TYPE string,
        time_end        TYPE string,
        check_switch_01 TYPE abap_bool VALUE abap_false,
        check_switch_02 TYPE abap_bool VALUE abap_false,
      END OF screen.

    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
    METHODS z2ui5_on_rendering
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_init.
  PRIVATE SECTION.
ENDCLASS.



CLASS yrgcl_abap2ui5_week2 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).
    ENDIF.
    z2ui5_on_event( client ).

    z2ui5_on_rendering( client ).
  ENDMETHOD.


  METHOD z2ui5_on_event.
    CASE client->get( )-event.

      WHEN 'BUTTON_SEND'.
        client->popup_message_box( 'success - values send to the server' ).
      WHEN 'BUTTON_CLEAR'.
        CLEAR screen.
        client->popup_message_toast( 'View initialized' ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).
      WHEN 'POST_PRESS'.
        client->popup_message_toast( text = |App executed on {  date DATE = USER } by { user } | ).
    ENDCASE.
  ENDMETHOD.


  METHOD z2ui5_on_init.

  ENDMETHOD.

  METHOD z2ui5_on_rendering.
    date = cl_abap_context_info=>get_system_date( ).
    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
             )->page(
                title          = 'Week 2 Challenge'
                navbuttonpress = client->_event( 'BACK' )
                  shownavbutton = abap_true
                )->header_content(
                    )->link( text = 'Source_Code'  target = '_blank' href = z2ui5_cl_xml_view=>hlp_get_source_code_url( app = me get = client->get( ) )
                )->get_parent( ).

    DATA(grid) = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).


    DATA(form) = grid->get_parent( )->get_parent( )->grid( 'L12 M12 S12'
        )->content( 'layout'
            )->simple_form( 'Form Title'
                )->content( 'form' ).

    DATA(lv_test) = form->label( 'User' )->input( value = client->_bind( user )  editable  = abap_true )->get_parent(  )->get_parent(  ).
    DATA(lv_date) =  form->label( 'Date' )->date_picker( value = client->_bind(  date ) )->get_parent( )->get_parent( ).
    DATA(lv_post_btn) = form->button( text = 'Post' press = client->_event( 'POST_PRESS' ) )->get_parent(  )->get_parent(  ).


    client->set_next( VALUE #( xml_main = page->get_root(  )->xml_get( ) ) ).
    client->set_next( VALUE #( xml_main = page->get_root(  )->xml_get( ) ) ).
  ENDMETHOD.
ENDCLASS.
