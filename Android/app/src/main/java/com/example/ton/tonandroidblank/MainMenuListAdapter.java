package com.example.ton.tonandroidblank;

import android.app.*;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * Created by Andrew on 2016-04-05.
 */
public class MainMenuListAdapter extends ArrayAdapter<String> {

    private final Activity context;
    private final String[] categories;
    private final Integer[] imageID;

    public MainMenuListAdapter(Activity context, String[] categories, Integer[] imageID) {
        super(context, R.layout.mainmenu_griditem_layout, categories);

        this.context = context;
        this.categories = categories;
        this.imageID = imageID;
    }

    public View getView(int position, View view, ViewGroup parent) {
        LayoutInflater inflater = context.getLayoutInflater();
        View itemView = inflater.inflate(R.layout.mainmenu_griditem_layout, null, true);

        TextView catTitle = (TextView) itemView.findViewById(R.id.catTitle);
        ImageView catIcon = (ImageView) itemView.findViewById(R.id.catIcon);

        catTitle.setText(categories[position]);
        catIcon.setImageResource(imageID[position]);

        return itemView;
    }

}
