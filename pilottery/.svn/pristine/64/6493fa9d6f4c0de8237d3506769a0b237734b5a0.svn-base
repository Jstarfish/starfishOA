#include "tsview.h"

#define TAB_KEY 9

/*
newwin ( int rows, int cols, int y, int x);

FIELD *new_field(int height, int width,   // new field size
                 int top, int left,       // upper left corner
                 int offscreen,           // number of offscreen rows
                 int nbuf);               // number of working buffers
*/

int  trimLength(char * ptr)
{
    int start;
    if (ptr)
    {
        for(start=0; !isspace(ptr[start]); start++)
            ;

        return (start);
    }
    else
        return 0;
}


void dialog_draw(dialog_struct * ptr)
{
    int i = 0;

    FORM  *ts_form;
	WINDOW *ts_form_win;
	int ch;
    int rows, cols;

    //Initialize the fields
    int lines = 0;
    int field_idx = 0;
    for (i=0; i<8; i++)
    {
        input_field *pInputField = &ptr->inputFieldArray[i];
        if (pInputField->used == 0)
            continue;

        ptr->field[field_idx] = new_field(1, pInputField->width, lines, pInputField->cols, 0, 0);
        set_field_fore(ptr->field[field_idx], COLOR_PAIR(8));
        set_field_back(ptr->field[field_idx], COLOR_PAIR(8));
        set_field_back(ptr->field[field_idx], A_UNDERLINE);
        field_opts_off(ptr->field[field_idx], O_AUTOSKIP);

        if (pInputField->flag == 0)
        {
            //只容许输入数字
            set_field_type(ptr->field[field_idx], TYPE_INTEGER, 0, 0, 0);
        }
        else
        {
            //容许输入数字和字母
            set_field_type(ptr->field[field_idx], TYPE_ALNUM, pInputField->width);
        }
            

        
        field_idx++;

        lines += 2;
    }
    for (i=field_idx; i<8; i++)
    {
        ptr->field[i] = NULL;
    }

    ts_form = new_form(ptr->field);

    /* Calculate the area required for the form */
    scale_form(ts_form, &rows, &cols);

    //ts_form_win = newwin(ptr->win_height, ptr->win_width, 10, 18);
    ts_form_win = newwin(rows+6, cols+8, 10, 18);
    keypad(ts_form_win, TRUE);

	/* Set main window and sub window */
    set_form_win(ts_form, ts_form_win);
    set_form_sub(ts_form, derwin(ts_form_win, rows, cols, 2, 2));
    //set_form_sub(ts_form, derwin(ts_form_win, rows, cols, lines, col));

	/* Print a border around the main window and print a title */
    box(ts_form_win, 0, 0);
    print_str(ts_form_win, 0, 3, ptr->title, A_BOLD|COLOR_PAIR(8), 0);
	
	post_form(ts_form);
	wrefresh(ts_form_win);

    lines = 2;
    for (i=0; i<8; i++)
    {
        input_field *pInputField = &ptr->inputFieldArray[i];
        if (pInputField->used == 0)
            continue;

        print_str(ts_form_win, lines, 2, pInputField->field_name, COLOR_PAIR(4), 0);
        lines += 2;
    }

    lines++;
    print_str(ts_form_win, lines, 2, "Type 'Enter' for confirm. 'Escape' for Cancel.", COLOR_PAIR(3), 0);

    set_current_field(ts_form, ptr->field[0]); /* Set focus to the colored field */

    refresh();
	form_driver(ts_form, REQ_FIRST_FIELD);

    //press "enter" key to confirm dialog
	while(true)
	{
	    ch = wgetch(ts_form_win);
        if (ch == 10)
        {
            //"enter"
            ptr->confirm = 1;
            break;
        }

        if ( (ch == 27) || (ch == 96) )
        {
            //"escape"
            ptr->confirm = 0;
            break;
        }

	    switch(ch)
		{
		    case KEY_DOWN:
                //将光标移到下一个选项处
                form_driver(ts_form, REQ_NEXT_FIELD);
                form_driver(ts_form, REQ_END_LINE);
                break;
			case KEY_UP:
                //将光标移到上一个选项处
                form_driver(ts_form, REQ_PREV_FIELD);
                form_driver(ts_form, REQ_END_LINE);
                break;
		    case TAB_KEY:
			    // Go to previous field
				form_driver(ts_form, REQ_PREV_FIELD);
				form_driver(ts_form, REQ_END_LINE);
				break;
		    case KEY_BACKSPACE:
            case KEY_DC:
			    // Go to previous field
				form_driver(ts_form, REQ_PREV_CHAR);
				form_driver(ts_form, REQ_DEL_CHAR);
				break;
		    case KEY_RIGHT:
			    // Go to previous field
				form_driver(ts_form, REQ_NEXT_CHAR);
				break;
			case KEY_LEFT:
			    // Go to previous field
				form_driver(ts_form, REQ_PREV_CHAR);
				break;
			default:
				// If this is a normal character, it gets Printed
				form_driver(ts_form, ch);
				break;
		}
	}

    //转存表单数据
    if (ptr->confirm == 1)
    {
        form_driver(ts_form, REQ_VALIDATION);
        for (i=0; i<8; i++)
        {
            if ( ptr->field[i] != NULL )
            {
                input_field *pInputField = &ptr->inputFieldArray[i];
                char *data = field_buffer(ptr->field[i], 0);

                int mylen = trimLength(data);
                strncpy(pInputField->field_value, data,mylen);
            }
        }
    }

    /* Un post form and free the memory */
	unpost_form(ts_form);
	free_form(ts_form);

    for (i=0; i<8; i++)
    {
        if ( ptr->field[i] != NULL )
            free_field( ptr->field[i] );
    }
	//endwin();
	return;   
}
