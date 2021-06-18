import { Component, OnInit } from '@angular/core';
import { Router }  from '@angular/router';
import { ApplicationInsights } from '@microsoft/applicationinsights-web';
import { AngularPlugin } from '@microsoft/applicationinsights-angularplugin-js';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'Tour of Heroes';
  constructor(private router: Router) { }

  ngOnInit() {
    if (environment.production) {
      const angularPlugin = new AngularPlugin();
      const appInsights = new ApplicationInsights({
        config: {
          instrumentationKey: environment.instrumentationKey,
          extensions: [ angularPlugin ],
          extensionConfig: {
            [angularPlugin.identifier]: {
              router: this.router
            }
          }
        }
      });
      appInsights.loadAppInsights();
      appInsights.addTelemetryInitializer(envelope => {
        if (envelope && envelope.tags) {
          envelope.tags['ai.cloud.role'] = 'spa-client';
        }
      });
      console.log('app insights is loaded');
    } else {
      console.log('app insights is not loaded');
    }
  }
}
