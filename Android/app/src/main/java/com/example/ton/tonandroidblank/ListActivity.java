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
                intent.putExtra("EXIT", true);
                startActivity(intent);
            }
        });

        String[] placeNames = {"Fairbanks Rescue Mission", "Interior Alaska Center for Non-violent Living",
                                "Fairbanks Youth Advocates The Door", "FCA Street Outreach and Advocacy Program",
                                "Stone Soup Cafe", "Immaculate Conception Church", "The Salvation Army", "FNA Elders Program",
                                "North Star Council on Aging", "Fairbanks Food Bank"};

        String[] placeDistances = {"0.2 mi", "0.5 mi", "0.7 mi", "1.2 mi", "1.2 mi", "1.3 mi", "1.5 mi",
                                    "1.9 mi", "2.0 mi", "2.5 mi"};


    }

}
