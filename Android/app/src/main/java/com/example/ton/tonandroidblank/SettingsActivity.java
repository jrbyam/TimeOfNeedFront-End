package com.example.ton.tonandroidblank;

import android.os.Bundle;
//import android.preference.PreferenceActivity;
import android.preference.PreferenceFragment;
import android.support.v7.app.AppCompatActivity;

/**
 * Created by Andrew on 2016-02-09.
 */
public class SettingsActivity extends AppCompatActivity{

    @Override
    protected void onCreate(Bundle savedInstance) {
        super.onCreate(savedInstance);
        getFragmentManager().beginTransaction().replace(android.R.id.content, new SettingsFragment()).commit();
    }

    public static class SettingsFragment extends PreferenceFragment
    {
        @Override
        public void onCreate(final Bundle savedInstanceState)
        {
            super.onCreate(savedInstanceState);
            addPreferencesFromResource(R.xml.preferences);
        }
    }
}
