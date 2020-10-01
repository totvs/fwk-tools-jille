import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { PersonalizationComponent } from './personalization/personalization.component';

const routes: Routes = [
  { path: 'personalization', component: PersonalizationComponent },
  { path: '', redirectTo: '/personalization', pathMatch: 'full' },
  { path: '**', component: PersonalizationComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
