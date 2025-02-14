import Component from "@glimmer/component";
import { service } from "@ember/service";
import avatar from "discourse/helpers/avatar";
import { i18n } from "discourse-i18n";

export default class TopicCreatorAvatar extends Component {
  @service router;

  get useTopicCreatorAvatarOnMobile() {
    return settings.use_topic_creator_avatar_mobile;
  }

  <template>
    {{#if this.useTopicCreatorAvatarOnMobile}}
      <a
        class="topic-list-left-creator-avatar"
        href={{@outletArgs.topic.firstPostUrl}}
        aria-label={{i18n "original_post"}}
        data-user-card={{@outletArgs.topic.creator.username}}
      >
        {{avatar @outletArgs.topic.creator imageSize="large"}}
      </a>
    {{else}}
      <a
        href={{@outletArgs.topic.lastPostUrl}}
        aria-label={{i18n
          "latest_poster_link"
          username=@outletArgs.topic.lastPosterUser.username
        }}
        data-user-card={{@outletArgs.topic.lastPosterUser.username}}
      >{{avatar @outletArgs.topic.lastPosterUser imageSize="large"}}</a>
    {{/if}}
  </template>
}
