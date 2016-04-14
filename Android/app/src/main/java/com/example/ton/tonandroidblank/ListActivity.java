package com.example.ton.tonandroidblank;

//import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.*;
import android.os.Process;
import android.preference.PreferenceManager;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListAdapter;
import android.widget.Toolbar;

/**
 * Created by Andrew on 2016-02-16.
 */
public class ListActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.list_layout);
       // Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
       // setSupportActionBar(toolbar);
        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(this);


        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        boolean showButton = settings.getBoolean("quickkill_switch", true);
        if (showButton)
            fab.show();
        else
            fab.hide();
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getApplicationContext(), BlankActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                intent.putExtra("EXIT", true); //Open the main activity and signal it to kill the PID.
                startActivity(intent);
            }
        });


    }

}
