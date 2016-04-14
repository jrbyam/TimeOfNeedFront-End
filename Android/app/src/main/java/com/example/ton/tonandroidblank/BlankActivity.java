package com.example.ton.tonandroidblank;

import android.app.*;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.view.ViewGroup;
import android.widget.Adapter;
import android.widget.GridView;
import android.widget.ArrayAdapter;
import android.widget.AdapterView;
import android.widget.ListAdapter;
import android.widget.Toast;


public class BlankActivity extends AppCompatActivity {

    MainMenuListAdapter myAdapter;
    GridView mainmenuGrid;
    String[] categories = {//getResources().getStringArray(R.array.category_titles);
            "Shelter",
            "Food",
            "Clothing",
            "Showers",
            "Support Groups",
            "Medical Facilities",
            "Employ-\nment",
            "Transport",
            "Suicide Prevention",
            "Domestic Violence",
            "Veteran Services",
            "Referral Services"
    };
    Integer[] imgID = {
            R.drawable.shelter_icon,
            R.drawable.food_icon,
            R.drawable.clothing_icon,
            R.drawable.showers_icon,
            R.drawable.support_groups_icon,
            R.drawable.medical_facilities_icon,
            R.drawable.employment_assistance_icon,
            R.drawable.transportation_assistance_icon,
            R.drawable.suicide_prevention_icon,
            R.drawable.domestic_violence_resources_icon,
            R.drawable.veteran_services_icon,
            R.drawable.sex_trafficking_resources_icon
    };

    protected void onCreate(Bundle savedInstanceState) {
        if (getIntent().getBooleanExtra("EXIT", false))
            android.os.Process.killProcess(android.os.Process.myPid());

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_blank);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(this);

        myAdapter = new MainMenuListAdapter(this, categories, imgID);
        mainmenuGrid = (GridView) findViewById(R.id.gridView);
        mainmenuGrid.setAdapter(myAdapter);
        //mainmenuGrid.setOnItemClickListener();


        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        boolean showButton = settings.getBoolean("quickkill_switch", true);
        if (showButton)
            fab.show();
        else
            fab.hide();
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                android.os.Process.killProcess(android.os.Process.myPid());
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_blank, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            Intent getScreenNameIntent = new Intent(this, SettingsActivity.class);
            startActivity(getScreenNameIntent);
            return true;
        }
        else
            {return super.onOptionsItemSelected(item);}
    }

    /*public void onSettingsClick (View view) {
        Intent getScreenNameIntent = new Intent(this, SettingsActivity.class);
        startActivity(getScreenNameIntent);
    }*/

    /*public void onCategory1Click (View view) {
        Intent getScreenNameIntent = new Intent(this, ListActivity.class);
        getScreenNameIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(getScreenNameIntent);
    } */

    /*public static class PlaceholderFragment extends Fragment {

        public PlaceholderFragment() {
        }

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            View rootView = inflater.inflate(R.layout.fragment_main, container, false);
            return rootView;
        }

    } //end fragment */
} //end activity
